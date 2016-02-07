---
id: 55
title: "Local DNS server and testing email delivery"
date: 2015-10-11 16:04:00 +0200
author: Dalibor Nasevic
tags: [ruby, dns, dig, mailcatcher, smtp]
---

Domain Name System (DNS) is one of the most important Internet protocol. It plays especially important role in email delivery being a prerequisite to Mail Transport Agents (MTAs). Running a local DNS test server to test various MTA configurations in an environment that can simulate production DNS is very helpful.

In this blog post I will not cover DNS theory, but rather focus on a practical examples and tools of how to run local DNS server and various tools I use for testing MTA configurations. I'll use Ubuntu (tested with 14.04), Ruby, [RubyDNS](https://github.com/ioquatix/rubydns), [mailcatcher](http://mailcatcher.me/) and [dig](https://en.wikipedia.org/wiki/Dig_(command)). If you're not familiar with DNS, here's an informative [tutorial](https://www.youtube.com/watch?v=72snZctFFtA) covering the basics.


### Disable OS DNS resolution

Before we disable the operating system's DNS resolution, let's install [RubyDNS](https://github.com/ioquatix/rubydns) that we'll use as our DNS server:

```bash
gem install rubydns
```

Now, let's disable DNS on Ubuntu. Comment out `dns=dnsmasq` line in `NetworkManager.conf` file and restart the `network-manager` service.

```bash
sudo vim /etc/NetworkManager/NetworkManager.conf
sudo service network-manager restart
```

After that, `network-manager` might update `/etc/resolv.conf` file and set your router as nameserver. If so, just edit that file and comment out the `nameserver` line to disable it.

```bash
sudo vim /etc/resolv.conf
# nameserver 192.168.100.1
```

Confirm that there is no local DNS server running:

```bash
ping google.com
# ping: unknown host google.com
```


### Run [RubyDNS](https://github.com/ioquatix/rubydns) DNS server

Create `dns.rb` file with the following content:

```ruby
require 'rubydns'

INTERFACES = [
  [:udp, "0.0.0.0", 53],
  [:tcp, "0.0.0.0", 53]
]

# Use upstream DNS for name resolution.
UPSTREAM = RubyDNS::Resolver.new([[:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]])

# Start the RubyDNS server
RubyDNS::run_server(:listen => INTERFACES) do
  match('www.example.com', Resolv::DNS::Resource::IN::A) do |transaction|
    transaction.respond!("127.0.0.1")
  end

  match('mail.example.com', Resolv::DNS::Resource::IN::A) do |transaction|
    transaction.respond!("127.0.0.1")
  end

  match("example.com", Resolv::DNS::Resource::IN::MX) do |transaction|
    transaction.respond!(10, Resolv::DNS::Name.create("mail.example.com."))
  end

  # Default DNS handler
  otherwise do |transaction|
    transaction.passthrough!(UPSTREAM)
  end
end
```

In the example above we have configured `A` and `MX` records and a passthrough to Google public DNS `8.8.8.8`. If you don't want to pass through DNS queries, you can disable it by commenting the `otherwise` block.

You will need `sudo` permissions to bind on port 53  that is the default DNS port. I'm using `rbenv` and `rbenv-sudo`, so the command to start `RubyDNS` server is:

```bash
rbenv sudo ruby dns.rb
```


### Query DNS server

To check if our local DNS server is running, let's query it. I use `dig` to query DNS, but there are other alternatives like `nslookup`, `host`, etc.

```bash
dig a www.example.com
```

You will get a longer response string that should have the following `ANSWER` section:

```bash
;; ANSWER SECTION:
www.example.com.	86400	IN	A	127.0.0.1
```

To see the most important part, use `+short` option:

```bash
dig a +short www.example.com
# 127.0.0.1
```

When debugging DNS, it's sometimes useful to specify which DNS server you want to query:

```bash
dig a +short www.example.com @127.0.0.1
# 127.0.0.1

dig a +short www.example.com @8.8.8.8
# 93.184.216.34
```

In the second query, we use the Google public DNS at `8.8.8.8` and we get the real IP address for `www.example.com`. While, in the first example we query the local DNS at `127.0.0.1` and we get the IP specified by `RubyDNS` config.


### How DNS resolution for email works

Let's say we want to send an email from `from@example.com`, to `to@example.com`.

What MTA will do is look for the domain part of the email, that is `example.com` and do a DNS lookup asking for the `MX` (Mail eXchanger) record:

```bash
dig mx +short example.com
# 10 mail.example.com.
```

The `MX` record specifies the mail server responsible for accepting email messages, in our case that is `mail.example.com`. And, for that domain we have an `A` record that specifies the mail server IP address.

```bash
dig a +short mail.example.com
# 127.0.0.1
```

Here's Ruby `net/smtp` example on how to send an email to that server. Add this in a file called `mail.rb`.

```ruby
require 'net/smtp'

from = 'from@example.com'
to   = 'to@example.com'

message = <<-MESSAGE
Date: Sun, 10 Oct 2015 10:00:00 +0000
From: #{from}
Subject: Test
To: #{to}
MIME-Version: 1.0
Content-Type: text/html; charset=UTF-8
MESSAGE

Net::SMTP.start('mail.example.com', 25) do |smtp|
  smtp.send_message message, from, to
end
```

Before, we run that file, let's setup `mailcatcher` that is a simple SMTP server that catches messages sent to it and displays them in a web interface. Install `mailcatcher` gem and start it with `sudo` permissions to bind to port 25 that is the default port for SMTP:

```bash
gem install mailcatcher
rbenv sudo mailcatcher --ip 0.0.0.0 --smtp-ip 0.0.0.0 --smtp-port 25 --http-port 1080 -f -v
# open http://localhost:1080/ for web interface
```

Once, that's running, let's send an email with:

```bash
ruby mail.rb
```

Then, in `mailcatcher` we should see the email:

![Mailcatcher](/images/mailcatcher.png "Mailcatcher")

With this setup, simulating production DNS and testing various MTA configs locally is really easy. It's often useful to configure the MTA (Postfix, PowerMTA or whatever) route emails to mailcatcher to check their content or to test the routing itself.
