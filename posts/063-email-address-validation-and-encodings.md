---
id: 63
title: "Email address validation and encodings"
date: 2015-12-20 00:15:00 +0100
author: Dalibor Nasevic
tags: [email, rfc, validation, encoding]
---

> How do you validate an email address?

That is a very interesting question to ask at job interviews and wait to hear the answer.

[RFCs](https://en.wikipedia.org/wiki/Request_for_Comments) are difficult to read and understand, and can be ambiguous at times. Theory is one thing, and implementation is another thing. In this blog post my focus are some interesting details about email addresses. I used [PowerMTA](https://en.wikipedia.org/wiki/PowerMTA) as testing MTA, version v4.0r20 (2015-09-11).

Let's start with a very simple regular expression for validating an email address:

```ruby
/.+@.+/
```

This regular expression is not very restrictive and will not produce false negatives. It says, the email address must have `@`, must have 1 or more characters in the local part (string before `@`), and must have 1 or more characters in the domain part (string after `@`).

Usually, we would want to check that there is also a dot in the domain part, although that's not required by the spec:

```ruby
/.+@.+\..+/
```

Here are few valid email addresses:

```text
pink.panther@localserver
pink.panther@[127.0.0.1]
pink.panther@example.com
pink\@panther@example.com
"pink@panther"@example.com
"pink panther"@example.com
```

The format for domain is more strict than the format for the local part. Domain can contain letters, digits, hyphens and dots. When domain part is an IP address it needs to be surrounded by square brackets. 

Local part can contain many special characters, and the following is a valid email address:

```text
"()<>[]:,;@\\\"! #$%&'*+-/=?^_`{}| ~.a"@example.com
```

Regular expressions for validating email addresses can be quite complex as this giant Perl [regular expression](http://www.ex-parrot.com/pdw/Mail-RFC822-Address.html) based on [RFC822](http://www.rfcreader.com/#rfc822) which is now obsolete. [RFC 2821](http://www.rfcreader.com/#rfc2821) (and better explained in [RFC3696](http://www.rfcreader.com/#rfc3696_line200)) defines the use of backslash for escaping. Examples of email addresses that the above regular expression will not match are:

```text
pink\@panther@example.com
pink\ panther@example.com
pink\\panther@example.com
```

### Validation strictness

That brings up the discussion for how strict email address validation you need in your application. That really depends on the context and why you're validating the email address.

Mail Transfer Agents are the ones that should implement things by the spec, but they not always do.

Email service providers (Gmail, Yahoo, etc) usually are more restrictive, for example they don't allow special characters in local part, which is not by the spec.

Other applications usually just need a very simple regular expression to check for `@` and `.` in domain part and should send an email to check validity via confirmation.

An interesting invalid email address by the spec is `pink..panther@example.com`. It's invalid because it has two consecutive dots which is not [allowed](http://serverfault.com/questions/395766/are-two-periods-allowed-in-the-local-part-of-an-email-address). PowerMTA allows 2 consecutive dots in the local part, but Gmail does not.


### Case sensitive local part

The following definition from [RFC5321](http://www.rfcreader.com/#rfc5321_line683) is interesting:

> The local-part of a mailbox MUST BE treated as case sensitive.
> Therefore, SMTP implementations MUST take care to preserve the case
> of mailbox local-parts.

The domain name part of an email address is not case sensitive, but the local part is case sensitive. However, because it will be confusing to users, email service providers does not support that.


### Email address length

If there is one RFC you should read about all these validations, that is [3696](http://www.rfcreader.com/#rfc3696) and its [errata](http://www.rfc-editor.org/errata_search.php?rfc=3696). It is short and human readable overview of formats for domain names, email addresses, URLs and URIs.

What is the length of an email address?

The correct answer seems to be in the errata with ID [1690](http://www.rfc-editor.org/errata_search.php?rfc=3696&eid=1690) from RFC [3696](http://www.rfcreader.com/#rfc3696_line200):

> In addition to restrictions on syntax, there is a length limit on
> email addresses.  That limit is a maximum of 64 characters (octets)
> in the "local part" (before the "@") and a maximum of 255 characters
> (octets) in the domain part (after the "@") for a total length of 320
> characters. However, there is a restriction in RFC 2821 on the length of an
> address in MAIL and RCPT commands of 254 characters.  Since addresses
> that do not fit in those fields are not normally useful, the upper
> limit on address lengths should normally be considered to be 254.

PowerMTA does not put the 254 limit on the email address, but just the 64 characters for local part and 255 for domain part. Gmail limits the local part to 30 characters.

The domain limit is specified in SMTP RFC [2821](http://www.rfcreader.com/#rfc2821_line2498) and in DNS RFC [1035](http://www.rfcreader.com/#rfc1035_line439), which also specifies the path of 256 including 2 characters for the angle brackets (`<>`).


### Punycode

[Punycode](https://en.wikipedia.org/wiki/Punycode) is a way to represent Unicode text with the limited subset of ASCII characters for domain names.

```ruby
# gem install simpleidn
>> require 'simpleidn'
=> true
>> SimpleIDN.to_ascii('münchen.com')
=> "xn--mnchen-3ya.com"
>> SimpleIDN.to_unicode('xn--mnchen-3ya.com')
=> "münchen.com"
```

When receiving mail server does not have the [SMTPUTF8](https://en.wikipedia.org/wiki/Extended_SMTP#SMTPUTF8) extension but supports UTF-8 email addresses, it expects punycoded domain.


### International email

[International email](https://en.wikipedia.org/wiki/International_email) (IDN email) is email that contains non-ASCII characters encoded as UTF-8 in both email headers and in mail transfer protocols.

I could not find an email service provider that allows you to create email address with UTF-8 characters (let me know if you have seen such?). You can use UTF-8 characters in Gmail suffix like so: dalibor.nasevic+idñ@gmail.com which is very handy for testing.

When sending an email to UTF-8 address at Gmail, it will use the SMTPUTF8 extension for support of UTF-8 encoding in mailbox names and header fields. PowerMTA does not have SMTPUTF8 just yet.


### MIME Encoded Word

In [RFC2047](http://www.rfcreader.com/#rfc2047) MIME Encoded Word is [defined](http://www.rfcreader.com/#rfc2047_line477).

Unicode text in headers can be encoded using a MIME "Encoded-Word". Here's an example:

```ruby
>> require 'mail'
=> true
>> puts Mail.new("Subject: idñ")[:subject].encoded
Subject: =?UTF-8?Q?id=C3=B1?=
```

The format is `=?charset?encoding?encoded text?=` and for more see [this](https://en.wikipedia.org/wiki/MIME#Encoded-Word). However, that's only used in email headers and does not work in envelope from / to fields.
