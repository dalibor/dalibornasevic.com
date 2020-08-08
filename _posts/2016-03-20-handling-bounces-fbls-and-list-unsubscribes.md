---
layout: post
title: "Handling bounces, FBLs and List-Unsubscribes"
date: 2016-03-20 16:20:00 +0100
categories: [email, smtp]
summary: "Strategies for processing and testing bounces, feedback loops (FBLs) and List-Unsubscribe requests in an email delivery system."
permalink: /posts/66-handling-bounces-fbls-and-list-unsubscribes
---

Handling Bounces, Feedback Loops (FBLs) and List-Unsubscribe requests is critical for the reputation of an email delivery system. Ignoring to process this valuable feedback from [Internet Service Providers](https://en.wikipedia.org/wiki/Internet_service_provider) (ISPs) will cause IPs to end-up on various [blacklists](https://en.wikipedia.org/wiki/DNSBL) and deliverability to suffer.

### Variable Envelope Return-Path (VERP)

[Variable Envelope Return Path](https://en.wikipedia.org/wiki/Variable_envelope_return_path) (VERP) is a technique for setting the "Return-Path" header field in order to be able to identify other details for a message on application side. "Return-Path" is the Envelope from address which tells the receiving mail server where to return the message if it needs to. It's different from the "From" header field.

To give a more practical example of how to use VERP, imagine there are 3 models in an application: `Email` that has one `Sender` and many `Recipient` models. The Return-Path of the email is set to a value like `user_1_email_2@example.com` and MTA software is configured to accept all incoming emails matching `/email_\d+_email_\d+@example.com/` pattern. Once an email is received and routed to the application, from the IDs in the local-part of the email address we can find the `Email`, `Sender` and `Recipient` models and do what's necessary with them.

Some might ask why not use a custom header field instead!? It's because some mail servers does not return all headers from the original message which leads to difficulties in determining the details.

### Hard, soft and general bounces

A bounce is an automated message sent from a receiving mail server back to the sending mail server to inform about a delivery problem. It can be sync or async in nature and it has a reason like: "bad-domain", "bad-mailbox", "quota-issues", "spam-related", "virus-related", etc.

Bounces are grouped in 3 groups:

- **Hard bounces**
  <p>Bounces that failed because of a permanent reason and should not be retried. In this group we have reasons like "bad-domain" and "bad-mailbox". Sending emails to non-existent mailbox will cause a reputation damage.</p>
- **Soft bounces**
  <p>Bounces that failed because of a temporary reason. They can be retried few times but if issue persist they should be treated as permanent. An example would be when an account is over quota limit.</p>
- **General bounces**
  <p>Bounces that failed because of a technical reason. They are usually treated as soft bounces, but they need to be carefully checked because they could hide an issue on the sending side like wrong format of the "From" header for an example.</p>

Some Message Transfer Agents (MTAs) provide support for processing bounces, but rolling out a custom [implementation](http://lindsaar.net/2008/3/24/handling-bounced-email-with-ruby-and-tmail) to [process](https://github.com/livebg/bounce_email/blob/master/lib/bounce_email.rb#L117) bounces is an option too.

Another alternative would be to use a commercial tool like [Bounce Studio](http://www.boogietools.com/Products/Linux/) which has a built-in heuristics to [categorize](http://www.boogietools.com/Products/Windows/BounceStudioEnterprise/help/files/bouncetypes.html) even the bounces that are not formatted by the [RFC 3463](http://www.rfcreader.com/#rfc3463) spec. That's where even commercial tools like PowerMTA's bounce and feedback loops processor fall short.

Simulating a bounce to test the bounce handling mechanism is as simple as sending an email in the right bounce format to a VERP address configured to handle bounces. Here's an example:

```ruby
require 'net/smtp'

verp = "user_1_email_2@bounces.example.com"
from = "sender@example.com"
to   = verp
host = 'mail.example.com'
port = 25

message = <<FOO
Date: Sun, 13 Sep 2015 08:11:19 +0000
From: #{from}
Subject: Delivery report
To: #{to}
MIME-Version: 1.0
Content-Type: multipart/report; report-type=delivery-status;
    boundary="report55F52FA7@example.com"


--report55F52FA7@example.com
Content-Type: text/plain

Hello, this is the mail server on example.com.

I am sending you this message to inform you on the delivery status of a
message you previously sent.  Immediately below you will find a list of
the affected recipients;  also attached is a Delivery Status Notification
(DSN) report in standard format, as well as the headers of the original
message.

  <none@example.com>  delivery failed; will not continue trying

--report55F52FA7@example.com
Content-Type: message/delivery-status

Reporting-MTA: dns;example.com
X-PowerMTA-VirtualMTA: {default}
Received-From-MTA: dns;localhost (192.168.33.1)
Arrival-Date: Sun, 13 Sep 2015 08:11:19 +0000

Final-Recipient: rfc822;none@example.com
Action: failed
Status: 5.1.2 (bad destination system: no such domain)
X-PowerMTA-BounceCategory: bad-domain

--report55F52FA7@example.com
Content-Type: text/rfc822-headers

Received: from localhost (192.168.33.1) by example.com id huknqe20ec0o for <none@example.com>; Sun, 13 Sep 2015 08:11:19 +0000 (envelope-from <someone@example.com>)
From: "Someone" <someone@example.com>
To: "None" <none@example.com>
Subject: Hello
Date: Wed, 11 May 2011 16:19:57 -0400

--report55F52FA7@example.com--
FOO

Net::SMTP.start(host, port) do |smtp|
  smtp.send_message message, from, to
end
```

The most interesting part is `Status: 5.1.2 (bad destination system: no such domain)` which contains the reason for the bounce.


### Feedback Loops (FBLs)

Feedback Loop (FBL) is an email message sent by a mailbox provider when a user clicks the "Report Spam" button in their UI. Word to the Wise blog has [info](https://wordtothewise.com/isp-information/) on ISPs that support FBLs and where to register with them.

Once registered for FBLs, ISPs will send reports to the email address registered with them. Similarly to bounces, FBLs can be processed within the MTA software if it supports that (PowerMTA for example does), tools like Bounce Studio or with a custom FBLs processor.

The standard [ARF](https://en.wikipedia.org/wiki/Abuse_Reporting_Format) format for reporting spam defines the following 5 types: "abuse", "fraud", "virus", "other" and "not-spam". Here's an example of how a feedback loop request would look like:

```ruby
require 'net/smtp'

verp = "user_1_email_2@example.com"
from = "sender@example.com"
to   = "fbls@example.com"
host = 'mail.example.com'
port = 25

message = %{
Date: Thu, 8 Mar 2005 17:40:36 EDT
From: <#{from}>
Subject: FW: Earn money
To: <#{to}>
MIME-Version: 1.0
Content-Type: multipart/report; report-type=feedback-report;
    boundary="part1_13d.2e68ed54_boundary"

--part1_13d.2e68ed54_boundary
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

This is an email abuse report for an email message received from IP
192.0.2.1 on Thu, 8 Mar 2005 14:00:00 EDT.  For more information
about this format please see http://www.mipassoc.org/arf/.

--part1_13d.2e68ed54_boundary
Content-Type: message/feedback-report

Feedback-Type: abuse
User-Agent: SomeGenerator/1.0
Version: 1
Original-Mail-From: <#{verp}>
Original-Rcpt-To: <user@example.com>
Arrival-Date: Thu, 8 Mar 2005 14:00:00 EDT
Reporting-MTA: dns; mail.example.com
Source-IP: 192.0.2.1
Authentication-Results: mail.example.com;
              spf=fail smtp.mail=#{verp}
Reported-Domain: example.net
Reported-Uri: http://example.net/earn_money.html
Reported-Uri: mailto:user@example.com
Removal-Recipient: user@example.com

--part1_13d.2e68ed54_boundary
Content-Type: message/rfc822
Content-Disposition: inline

From: <#{verp}>
Received: from mailserver.example.net (mailserver.example.net
    [192.0.2.1]) by example.com with ESMTP id M63d4137594e46;
    Thu, 08 Mar 2005 14:00:00 -0400

To: <Undisclosed Recipients>
Subject: Earn money
MIME-Version: 1.0
Content-type: text/plain
Message-ID: 8787KJKJ3K4J3K4J3K4J3.mail@example.net
Date: Thu, 02 Sep 2004 12:31:03 -0500

Spam Spam Spam
Spam Spam Spam
Spam Spam Spam
Spam Spam Spam
--part1_13d.2e68ed54_boundary--

Example 1: Generic abuse report with maximum returned information

A contrived example in which the report generator has returned all
possible information about an abuse incident.
}

Net::SMTP.start(host, port) do |smtp|
  smtp.send_message message, from, to
end
```

The most important part is the `Feedback-Type` value which specifies the FBL type.

### List-Unsubscribe

[List-Unsubscribe](http://www.list-unsubscribe.com/) is an optional header field defined in [RFC 2369](http://www.rfcreader.com/#rfc2369). ISP that support the List-Unsubscribe header (Gmail for example) will provide a botton in their UI for users to unsubscribe without going to the ESP's website. List-Unsubscribe header is not a substitute method for unsubscribing, there still needs to be an unsubscribe link visible in the email content.

List-Unsubscribe can be either a mailto and/or URI. There are some email providers like Microsoft that support [only mailto](https://mail.live.com/mail/junkemail.aspx). So the recommendation is to always have mailto and optionally use URI version.

```ruby
List-Unsubscribe: <mailto:user_1_email_2@unsubscribes.example.com?subject=Unsubscribe user 1, email 2>, <http://example.com/unsubscribe/?user=1&email=2>
```

Here is an example of how to simulate List-Unsubscribe request:


```ruby
require 'net/smtp'

verp = "user_1_email_2@unsubscribes.example.com"
from = "sender@example.com"
to   = verp
host = 'mail.example.com'
port = 25

message = %{
Date: Sun, 13 Sep 2015 08:11:19 +0000
From: #{from}
Subject: Unsubscribe example
To: #{to}
MIME-Version: 1.0

This message was automatically generated by Unsubscribe Tester.
}

Net::SMTP.start(host, port) do |smtp|
  smtp.send_message message, from, to
end
```

Do you have your own email delivery infrastructure or you are using an external service for sending emails from your applications?
