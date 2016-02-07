---
id: 61
title: "Intro to Machine Learning in Ruby"
date: 2015-11-18 08:39:00 +0100
author: Dalibor Nasevic
tags: [machine-learning, ruby]
---

**Note**: This is a republish of an article I wrote back in December 2011 on [Siyelo blog](http://blog.siyelo.com/intro-to-machine-learning-in-ruby/).

Machine learning is branch of <strong>A</strong>rtificial <strong>I</strong>ntelligence (AI) concerned with design and development of algorithms that allow computers to learn. It's a very broad subject so we will just focus on a simple example that uses statistical classification.

### Let's build...

In this tutorial we are going to build a simple news classification application that will parse and classify RSS/HTML articles from the [Times Live](http://www.timeslive.co.za/) newspaper.

For the job, we will use **nokogiri** gem and 2 ruby standard libraries: **open-uri** and **rss/2.0**.

### RSS Parser

To find sources of articles for processing, we could build a complex search engine or we can simply use the RSS feeds the newspaper provides us with to look for and discover links. **RssParser** class does exactly that, you initialize it with a [feed url](http://avusa.feedsportal.com/c/33051/f/534658/index.rss) and it gives you back the links to all the articles discovered in that feed.

```ruby
class RssParser
  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def article_urls
    RSS::Parser.parse(open(url), false).items.map{ |item| item.link }
  end
end
```

### HTML Parser

Having article links, we need to parse page content and extract meaningful parts from these pages. **HtmlParser** class can be initialized with a page url and DOM selector. In this example we will be using a CSS selector to extract the content from articles - [Firebug](http://getfirebug.com/) and [jQuery](http://jquery.com/) were used to find the selector for the text we are extracting from the article. In this class you will also notice **clean_whitespace** method which cleans the whitespace characters from the extracted text.

```ruby
class HtmlParser
  attr_accessor :url, :selector

  def initialize(url, selector)
    @url      = url
    @selector = selector
  end

  def content
    doc = Nokogiri::HTML(open(url))
    html_elements = doc.search(selector)
    html_elements.map { |element| clean_whitespace(element.text) }.join(' ')
  end

  private

  def clean_whitespace(text)
    text.gsub(/\s{2,}|\t|\n/, ' ').strip
  end
end
```

### Statistical Classifier

We introduce a class that is responsible for classification of articles. It is initialized with a hash that consists of categories (keys) and training data (values).

Training data is used to discover potential relationships between articles and categories. This data should be carefully selected in order to give better classification results. It is created by determining the value for each word in the context of all words for that category (see the **train_data()** method).

In this example we are using content of Wikipedia articles for [economy](http://en.wikipedia.org/wiki/Economy), [sport](http://en.wikipedia.org/wiki/Sport) and [health](http://en.wikipedia.org/wiki/Health) as training data for our categories.

When classifying articles we want to compare only meaningful words and ignore other words that do not add any value for a certain category. We (partially) solve this problem using [stop words](https://gist.github.com/1534053).

Finally, the **scores()** method creates the scores for each category (per text) that we are testing.


```ruby
class Classifier
  attr_accessor :training_sets, :noise_words

  def initialize(data)
    @training_sets = {}
    filename = File.join(File.dirname(__FILE__), 'stop_words.txt')
    @noise_words = File.new(filename).readlines.map(&:chomp)
    train_data(data)
  end

  def scores(text)
    words = text.downcase.scan(/[a-z]+/)

    scores = {}
    training_sets.each_pair do |category, word_weights|
      scores[category] = score(word_weights, words)
    end

    scores
  end

  def train_data(data)
    data.each_pair do |category, text|
      words = text.downcase.scan(/[a-z]+/)
      word_weights = Hash.new(0)

      words.each {|word| word_weights[word] += 1 unless noise_words.index(word)}

      ratio = 1.0 / words.length
      word_weights.keys.each {|key| word_weights[key] *= ratio}

      training_sets[category] = word_weights
    end
  end

  private

  def score(word_weights, words)
    score = words.inject(0) {|acc, word| acc + word_weights[word]}
    1000.0 * score / words.size
  end
end
```

### Lets have a go

Here is the script that runs the program:

```ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'rss/2.0'

# training data samples
economy = HtmlParser.new('http://en.wikipedia.org/wiki/Economy', '.mw-content-ltr')
sport   = HtmlParser.new('http://en.wikipedia.org/wiki/Sport', '.mw-content-ltr')
health  = HtmlParser.new('http://en.wikipedia.org/wiki/Health', '.mw-content-ltr')

training_data = {
  :economy => economy.content,
  :sport => sport.content,
  :health => health.content
}

classifier = Classifier.new(training_data)

results = {
  :economy => [],
  :sport => [],
  :health => []
}

rss_parser = RssParser.new('http://avusa.feedsportal.com/c/33051/f/534658/index.rss')
rss_parser.article_urls.each do |article_url|
  article = HtmlParser.new(article_url, '#article .area > h3, #article .area > p, #article > h3')
  scores = classifier.scores(article.content)
  category_name, score = scores.max_by{ |k,v| v }
  results[category_name] << article_url
end

p results
```

Although our statistical classification algorithm is very simple, it can give remarkably good results provided the training data is good. For even better results you can try other classification algorithms like [Bayesian probability](http://en.wikipedia.org/wiki/Bayesian_probability) and [Latent Semantic Analysis](http://en.wikipedia.org/wiki/Latent_semantic_analysis).

If you are interested in a more indepth example of a news aggregator application - you can check [newsagg](https://github.com/dalibor/newsagg) at Github. It's a simple Sinatra application with a Redis datastore that I put together. It crawls, classifies and creates 'clusters' of articles using statistical algorithms.

If you want to learn more about Machine Learning, checkout [Programming Collective Intelligence](http://shop.oreilly.com/product/9780596529321.do) book - code examples written in Python and [Scripting Intelligence](http://www.apress.com/9781430223511) - code examples written in Ruby.
