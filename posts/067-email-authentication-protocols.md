---
id: 67
title: "Email Authentication Protocols"
date: 2016-03-23 18:10:00 +0100
author: Dalibor Nasevic
tags: [email, authentication, protocols]
---

Email authentication can be very confusing and it can take time to grasp it. One of the reasons for writing this post is to document these things for myself for future reference.

When [Simple Mail Transfer Protocol](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol) (SMTP) was designed in 1982 ([RFC 821](http://www.rfcreader.com/#rfc821)), it did not provide any way to identify message senders. A system lacking that component was easy to abuse by spammers. It was clear that SMTP was in need for techniques to prevent spam and identify the origin of a message.

### HELO check

In order to be able to receive emails from the internet, a domain needs to have a MX record with the mail server hostname responsible for accepting emails:

```bash
$ dig mx +short example.com
10 mail.example.com.
```

Mail server hostname needs an A record that resolves to an IP address:

```bash
$ dig a +short mail.example.com
127.0.0.1
```

The IP address needs to have a reverse PTR record resolving to the same hostname.

```bash
$ dig -x 127.0.0.1 +short
mail.example.com.
```

Reverse PTR record is often checked by spam filters before accepting emails originating from that mail server. That check is done when the sending mail server sends the HELO/EHLO greeting with its [Fully Qualified Domain Name](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) (FQDN) to the receiving mail server.

```bash
$ telnet receiving.example.com 25
Trying 127.0.0.1...
Connected to receiving.example.com.
Escape character is '^]'.
220 ****************************************
HELO sending.example.com
250 receiving.example.com says hello
```

### Sender Policy Framework (SPF)

[Sender Policy Framework](http://en.wikipedia.org/wiki/Sender_Policy_Framework) (SPF) is an email validation system defined with [RFC 4408](http://www.rfcreader.com/#rfc4408). It is used to specify which network hosts are allowed to send mail from a domain. SPF originally used TXT record in DNS, then in 2005 [IANA](https://en.wikipedia.org/wiki/Internet_Assigned_Numbers_Authority) assigned the Resource Record type 99 to SPF but later it was discontinued and the standard today is to use a TXT record.

SPF specification states that clients must check the "MAIL FROM" identity (Return-Path) and it recommends that clients also check the "HELO" identity.

Here is an example policy for the example.com domain:

```bash
$ dig txt +short example.com
"v=spf1 ip4:127.0.0.1/27 ~all"
```

Where, `v=spf1` specifies the version, `ip4:127.0.0.1/27` is the IP CIDR range that's allowed to send email with "Return-Path" and "HELO" identity set to an email address at the domain, and `~all` is a qualifier for how the results should be interpreted if the policy does not align.

### Sender-ID

[Sender-ID](https://en.wikipedia.org/wiki/Sender_ID) is an obsolete protocol that was defined in [RFC 4406](http://www.rfcreader.com/#rfc4406) and was introduced by Microsoft as a derivation of SPF. It validates the identity of the message defined as [Purported Responsible Address](http://www.rfcreader.com/#rfc4407) which can be "Sender" or "From" header field.

An interesting problem with Sender-ID is the conflicting spec with the SPF protocol because it suggests using `v=spf1` as equivalent to `spf2.0/mfrom,pra`. What that means is, when a domain has `v=spf1` policy published to protect its use in "MAIL FROM" and "HELO" addresses, Sender ID implementations that apply that policy to PRA will reject the mail when the domain is used in the "From" header field but not in the "MAIL FROM". That is actually a very common use case when sending mail from ESPs.

### Domain Keys

[DomainKeys](https://en.wikipedia.org/wiki/DomainKeys) (DK) is a deprecated e-mail authentication system designed by Yahoo and defined in [RFC 4870](https://tools.ietf.org/html/rfc4870). It was used to verify the message integrity using a standard public/private key signing process. Some aspects of it are included in DomainKeys Identified Mail (DKIM) which is used today.

### DKIM

[DomainKeys Identified Mail](http://en.wikipedia.org/wiki/DomainKeys_Identified_Mail) (DKIM) is a protocol defined with [RFC 4871](http://www.rfcreader.com/#rfc4871) used to verify that the email was authorized to be send from a domain. It also verifies that the message content did not change from the moment the message left the initial mail server until it was received by receiving mail server.

A message signed with DKIM will have a header like this:

```bash
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; s=selector; d=example.com;
```

Where, `v=1` is the version of the DKIM spec used, `a` is the algorithm which can be "rsa-sha1" or "rsa-sha256", `s` is the selector that is also used to locate the DNS record and `d` is the signing domain.

In order for receiving mail server to check the message integrity it first need to get the public key for the selector used in the email's DKIM signature from the TXT record on the signing domain:

```bash
$ dig txt +short selector._domainkey.example.com
"v=DKIM1\; k=rsa\; p=public_key\;"
```

### DMARC

[Domain-based Message Authentication, Reporting and Conformance](https://en.wikipedia.org/wiki/DMARC) (DMARC) is an email validation system build on top of SPF and DKIM, defined in [RFC 7489](http://www.rfcreader.com/#rfc7489) which provide domain-level authentication.

A DMARC policy allows a sender's domain to indicate that their emails are protected by SPF and/or DKIM, and tells a receiver what to do if neither of those authentication methods pass.

An example of what DMARC can do is the Yahoo's recent [change](https://help.yahoo.com/kb/SLN24016.html) to `p=reject` in their DMARC policy, which tells ISPs to reject emails that have "From" address set to a Yahoo address if the emails are sent from mail servers that are not whitelisted by Yahoo's SPF policy.

```bash
dig txt +short _dmarc.yahoo.com
"v=DMARC1\; p=reject\; pct=100\; rua=mailto:dmarc_y_rua@yahoo.com\;"
```

### Port25 verifier

Port 25 has a handy tool to help debug email authentication protocols by sending an email to an address in format `check-auth-user=example.com@verifier.port25.com`. Instead of `user=example.com` you need to provide your email address in that format where you want to get the report with results from the email authentication.
