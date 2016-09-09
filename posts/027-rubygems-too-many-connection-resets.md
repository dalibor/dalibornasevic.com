---
id: 27
title: "Rubygems: too many connection resets"
date: 2011-09-01 22:06:00 +0200
author: Dalibor Nasevic
tags: [rubygems, ruby, gem]
---

**Update**: This issue is now fixed. As noted in the comments by Erik Michaels-Ober, patch has been [committed](https://github.com/rubygems/rubygems.org/commit/9eb072cc5a0283dd059447c3e537c35ea47dad39 "Rubygems patch") and deployed to the API of Rubygems website.

I built a very small gem yesterday for translating model fields stored in the same model [model\_fields\_i18n](https://github.com/dalibor/model_fields_i18n "Translate model fields stored in the same model") and was trying to push it to Rubygems, but was getting this error:

```bash
$ gem push pkg/model_fields_i18n-0.0.1.gem 
Pushing gem to https://rubygems.org...
ERROR:  While executing gem ... (Gem::RemoteFetcher::FetchError)
    too many connection resets (https://rubygems.org/api/v1/gems)
```

Trying different connections didn't helped and also Google search didn't reveal anything. But, today I found a very fresh solution on Rubygems [support page](http://help.rubygems.org/discussions/problems/715-too-many-connection-resets "Rubygems support page") which I think is worth sharing here. So, when you try pushing a gem to Rubygems using:

```bash
$ gem push model_fields_i18n-0.0.1.gem
```

gem push command asks you for your credentials which if you set correctly, they will be stored in the `~/.gem/credentials` file and in a wrong format like:

```yaml
--- 
:rubygems_api_key: "{\"rubygems_api_key\":\"1234567890\"}"
```

To fix the issue, you need to change the format as:

```yaml
--- 
:rubygems_api_key: "1234567890"
```

Then you can successfully push your gem to Rubygems.

```yaml
$ gem push pkg/model_fields_i18n-0.0.1.gem 
Pushing gem to https://rubygems.org...
Successfully registered gem: model_fields_i18n (0.0.1)
```

On the other note, if you want to build your own gem with the latest best practices in mind, I recommend reading this great [Extending Active Record](http://ryanbigg.com/2011/01/extending-active-record/ "Extending Active Record") blog post by Ryan Bigg and also you can check [New Gem with Bundler](http://railscasts.com/episodes/245-new-gem-with-bundler "New Gem with Bundler") Railscast.
