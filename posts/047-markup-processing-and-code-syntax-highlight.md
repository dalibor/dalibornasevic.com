---
id: 47
title: "Markup processing and code syntax highlight"
date: 2014-08-02 16:50:00 +0200
author: Dalibor Nasevic
tags: [ruby, markup, syntax, highlight]
---

I changed the code syntax highlighting on my blog. I was using [Syntax Highlighter](http://alexgorbatchev.com/SyntaxHighlighter/) Javascript tool that does its work on the fly in browser. I wanted something more light-weight to the browser that I can also script easily for my other needs, like building PDF presentations.

I like writing markdown and generating HTML from it, and I like how Github is doing markdown to HTML conversion and syntax highlighting. So, that was the direction I looked for tools. Here's what I did to change the syntax highlighting on my blog with Ruby tools and without much efforts.


### 1. Converting HTML to markdown

My old posts were written with [wymeditor](http://www.wymeditor.org/) (that also got removed, btw). So, first I needed a tool to convert everything from HTML to markdown.

I used [reverse_markdown](https://github.com/xijo/reverse_markdown) gem for that, install it with:

```bash
gem install reverse_markdown
```

I exported my database to csv format, and then converted each HTML post to markdown with this simple script.

```ruby
require 'csv'
require 'reverse_markdown'

posts = File.read("posts.csv")

CSV.parse(posts, :headers => true) do |row|
  id = "%03d" % row['id']
  File.open("posts/#{id}.md", 'w') do |file|
    file.puts ReverseMarkdown.convert(row['content'].gsub("\r", ''))
  end
end
```

The gsub above was used to remove some return characters that somehow got inserted in the HTML. I then manually reviewed the converted files and did a format cleanup to a style that I prefer.


### 2. Converting markdown to HTML and adding syntax highlight

On my Ubuntu system, I had the install the following dependencies:

```bash
sudo apt-get install libicu-dev
sudo apt-get install cmake
```

Then, install the following gems:

```bash
gem install github-markup   # convert markdown to html
gem install github-markdown # github flavored markdown
gem install github-linguist # detect languages, highlight code
gem install redcarpet       # markdown parser
gem install html-pipeline   # html processing filters and utilities
```

And finally, here the script:


```ruby
require 'github/markup'
require 'html/pipeline'

Dir.glob('posts/*.md') do |file|
  pipeline = HTML::Pipeline.new [
    HTML::Pipeline::MarkdownFilter,
    HTML::Pipeline::SyntaxHighlightFilter
  ]

  result = pipeline.call(File.read(file))

  html_file = "#{file.match('\d+')[0]}.html"
  File.open("html/#{html_file}", 'w') do |file|
    file.puts result[:output].to_s
  end
end
```

In the script:

1. we convert the markdown to html with [github-markup](https://github.com/github/markup), [redcarpet](https://github.com/vmg/redcarpet) and github flavored markdown (`HTML::Pipeline::MarkdownFilter` uses [github-markdown](https://rubygems.org/gems/github-markdown))
2. we do syntax highlighting (`HTML::Pipeline::SyntaxHighlightFilter` uses [pygments.rb](https://github.com/tmm1/pygments.rb)).

[pygments.rb](https://github.com/tmm1/pygments.rb) is a Ruby wrapper for the [Python pygments syntax highlighter](http://pygments.org/). 

Finally, having the HTML ready, we just need to include some CSS styles to style the code. You can use `pygments.rb` gem to generate CSS styles:

```ruby
Pygments.css('.highlight')
Pygments.css('.highlight', :style => "monokai") # if you want a specific theme
```

 Alternatively, you can find some CSS [styles for pygments](https://github.com/cstrahan/pygments-styles/tree/master/themes). On my blog I use the [jellybeans](https://github.com/cstrahan/pygments-styles/blob/master/themes/jellybeans.css) theme that I also use in my vim.
