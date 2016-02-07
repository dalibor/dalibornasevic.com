---
id: 24
title: "jQuery.tweets and jQuery.tracks plugins"
date: 2011-03-31 23:14:00 +0200
author: Dalibor Nasevic
tags: [jQuery, javascript, twitter, last.fm, json, plugin]
---

I just extracted 2 small jQuery plugins from [my blog](http://dalibornasevic.com/) which I use for displaying recent tweets from my [Twitter](http://twitter.com/dnasevic "Dalibor Nasevic's Twitter profile") profile and recent tracks from my [Last.fm](http://www.last.fm/user/blackflasher "Dalibor Nasevic's Last.fm profile") profile. Both plugins use the JSON APIs, and you can check them on my Github profile:

- [jQuery.tweets](https://github.com/dalibor/jQuery.tweets "jQuery.tweets plugin") - displays recent tweets from a Twitter profile. 
- [jQuery.tracks](https://github.com/dalibor/jQuery.tracks "jQuery.tracks plugin") - displays recent tracks from a Last.fm profile.

Clone the repositories, see index.html source for usage. And, read the source code if you are interested to build jQuery plugins.

Both plugins have dependency of 2 small jQuery plugins that you may also find interesting to use or just read their source code:

- [jquery-timeago.js](https://github.com/rmm5t/jquery-timeago "jQuery timeago") - approximate distance in time
- [jquery-autolink.js](http://kawika.org/jquery/js/jquery.autolink.js "jQuery autolink") - automatically creates links
