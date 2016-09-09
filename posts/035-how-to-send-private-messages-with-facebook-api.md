---
id: 35
title: "How to send private messages with Facebook API"
date: 2012-07-23 20:05:00 +0200
author: Dalibor Nasevic
tags: [social, import, integration, facebook]
summary: "Sending private message on Facebook using Facebook Chat API."
---

**Update**: [Facebook Chat API](https://developers.facebook.com/docs/chat) has been deprecating and this hack does not work anymore.

You want to send private messages (invite friends to your application) with Facebook API but did not find any solution on Stack Overflow ([1](http://stackoverflow.com/questions/2574431/facebook-api-send-private-messages-to-friends), [2](http://stackoverflow.com/questions/4363515/sending-private-messages-through-facebook-api), [3](http://stackoverflow.com/questions/8472290/php-graph-api-to-send-private-messages-to-friends), [4](http://stackoverflow.com/questions/4346884/post-a-private-message-to-the-user-frined-using-ruby-and-fb-graph-gem), [5](http://stackoverflow.com/questions/4667093/sending-private-messages-to-facebook-accounts-using-ruby-on-rails), [6](http://stackoverflow.com/questions/6940018/using-fbgraph-api-for-private-messaging), [7](http://stackoverflow.com/questions/7994122/facebook-app-invite-from-ruby-on-rails), ...) because Facebook Graph API does not allow to send/reply/delete messages, only allows to  [view a message](http://developers.facebook.com/docs/reference/api/message/ "Facebook Graph API - Message ")!?

Here is the trick.

It's possible to send messages using  [Facebook Chat API](http://developers.facebook.com/docs/chat/ "Facebook Chat API"), and if the Facebook friend is offline the message will be displayed in the normal message UI on Facebook, otherwise in the chat window. To be able to send chat messages we need to ask for  **xmpp\_login** permissions in the Facebook application.

If we are using [Devise](https://github.com/plataformatec/devise/ "devise gem") with [OmniAuth](https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview "Devise OmniAuth") in Ruby on Rails framework, we can ask for xmpp\_login permissions in initializers/devise.rb with:

```ruby
config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], :scope => 'xmpp_login'
```

Sending a message is easy using the  [xmpp4r\_facebook](https://github.com/kissrobber/xmpp4r_facebook "xmpp4r\_facebook") gem like this:

```ruby
sender_chat_id = "-#{sender_uid}@chat.facebook.com"
receiver_chat_id = "-#{receiver_uid}@chat.facebook.com"
message_body = "message body"
message_subject = "message subject"

jabber_message = Jabber::Message.new(receiver_chat_id, message_body)
jabber_message.subject = message_subject

client = Jabber::Client.new(Jabber::JID.new(sender_chat_id))
client.connect
client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client,
   ENV.fetch('FACEBOOK_APP_ID'), facebook_auth.token,
   ENV.fetch('FACEBOOK_APP_SECRET')), nil)
client.send(jabber_message)
client.close
```

But... first we need to register Facebook application to get the APP ID and APP SECRET. Then we need to authenticate the user on Facebook with OmniAuth to get their uid - **sender\_uid** and then we need to import their contacts to get a single **receiver\_uid**  that the sender wants to message. We can use the  [koala](https://github.com/arsduo/koala/ "koala gem") gem for importing Facebook contacts.

For Twitter and Linkedin we can use [twitter](https://github.com/sferik/twitter "twitter gem") and [linkedin](https://github.com/pengwynn/linkedin "linkedin gem") gems for both import and private messaging.
