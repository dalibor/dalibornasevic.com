---
layout: post
title: "Blog update and UI redesign"
date: 2011-03-23 22:38:00 +0100
categories: [blog, rails, jquery, ui, ruby.mk]
summary: "Some changes on my blog including UI redesign."
permalink: /posts/22-blog-update-and-ui-redesign
---

I have upgraded [my blog application](https://github.com/dalibor/dalibornasevic.com "Blog application") from Rails 2.3.x to Rails 3 and re-designed the UI.

Here is short summary of changes:

- Removed Akismet integration, added reCaptcha
- Removed textile support, added [WYMeditor](http://www.wymeditor.org/ "WYMeditor")
- Removed [SHJS](http://shjs.sourceforge.net/), added [SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/) for syntax highligh
- Introduced [web-app-theme](http://pilu.github.com/web-app-theme/%20 "Rails Admin theme") to the admin interface
- Added support for multiple editors on the blog
- Introduced HTML5 boilerplate template
- Usage of HTML5 elements and CSS3 styles
- Complete re-design of the UI
- Better testing stack & updated Cucumber scenarios and RSpec specs

Future plans:

- Customization support (make it easy for users to customize and deploy the application)
- Add support for editors to just add their RSS feed URL if they don't want to write posts (useful when deployed as a "team blog")
- Deploy the application as "team blog" to [ruby.mk](http://ruby.mk "MKRUG official site") where it will allow editors that don't have their existing blog to write posts and also allow editors that have their existing blog only to submit their RSS feed URL
- Extract jQuery.tweets & jQuery.tracks as independent plugins (latest tweets/tracks from Twitter/Last.fm, see the [homepage](/))
