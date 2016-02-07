---
id: 9
title: "Ruby Singleton Pattern"
date: 2010-01-24 18:26:00 +0100
author: Dalibor Nasevic
tags: [ruby, singleton, patterns, rails]
---

Singleton is perhaps the most hated of all programming patterns. You can read some of the reasons for this in [Why Singletons are Evil](http://blogs.msdn.com/scottdensmore/archive/2004/05/25/140827.aspx "Why Singletons are Evil"). But, I think it has some good usages. I will start by describing what a singleton pattern is, walk through different ways of implementing it in Ruby, and point to how it's used in Rails.

Singleton is a design pattern that restricts instantiation of a class to only one instance that is globally available. It is useful when you need that instance to be accessible in different parts of the application, usually for logging functionality, communication with external systems, database access, etc.

There are few ways of implementing singleton pattern in Ruby:

### Single Instance of a class

```ruby
class Logger
  def initialize
    @log = File.open("log.txt", "a")
  end
  
  @@instance = Logger.new

  def self.instance
    return @@instance
  end

  def log(msg)
    @log.puts(msg)
  end

  private_class_method :new
end

Logger.instance.log('message 1')
```

In this code example, inside class Logger we create instance of the very same class Logger and we can access that instance with class method `Logger.instance` whenever we need to write something to the log file using the instance method `log`. In the `initialize` method we just opened a log file for appending, and at the end of Logger class, we made method `new` private so that we cannot create new instances of class Logger. That is Singleton Pattern: only one instance, globally available.

### Ruby Singleton module

Ruby Standard Library has a Singleton module which implements the Singleton pattern. Previous example when using the Singleton module would translate to:

```ruby
require 'singleton'

class Logger
  include Singleton
  
  def initialize
    @log = File.open("log.txt", "a")
  end

  def log(msg)
    @log.puts(msg)
  end
end

Logger.instance.log('message 2')
```

Here we require and include `Singleton` module inside `Logger` class, define `initialize` method which opens the log file for appending and instance method `log` for writing to that log file. Ruby Singleton module does lazy instantiation (creates instance from Logger class at the moment when we call `Logger.instance` method) and not during load time (like in the previous example). Also, Ruby Singleton module makes `new` method private, so we don't have to call `private\_class\_method`.

Now, we can look at some of the alternative ways of implementing similar functionality to Singleton Pattern in Ruby:

### Global variable

Because singleton instance should be globally available, we can create a global variable $logger and use it as reference to Logger instance. But, global variables are usually a bad idea, the problem is that they can be redefined during runtime without noticing that.

```ruby
$logger = Logger.new
$logger.log("message 3")
```

### Constant

On the other side, constants cannot be redefined, but we still have problems with lazy instantiation as in the case with a global variable.

```ruby
LOGGER = Logger.new
LOGGER.log("message 4")
```

### Class

Singleton pattern can also be implemented using class methods and class variables. Using class methods we are sure that we have a single instance.

```ruby
class Logger

  def self.log(msg)
    @@log ||= File.open("log.txt", "a")
    @@log.puts(msg)
  end
end

Logger.log('message 5')
```

### Module

Similar to class implementation, with the advantage that modules can't be instantiated. I generally prefer this way when using this pattern.

```ruby
module Logger
  def self.log(msg)
    @@log ||= File.open("log.txt", "a")
    @@log.puts(msg)
  end
end
```

### Singleton Pattern used in Rails

Rails is using the singleton pattern to implement [class Inflections](http://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflector/inflections.rb "Rails class inflections"). It is a single instance (`Inflections.instance`) that gives global access to all inflection rules used in different parts of Rails. Here is a code example (methods are empty for simplification):

```ruby
module ActiveSupport
  module Inflector
    class Inflections
      def self.instance
        @ __instance__ ||= new
      end

      attr_reader :plurals, :singulars, :uncountables, :humans

      def initialize
        @plurals, @singulars, @uncountables, @humans = [], [], [], []
      end

      def plural(rule, replacement)
      end

      def singular(rule, replacement)
      end

      def irregular(singular, plural)
      end

      def uncountable(*words)
      end

      def human(rule, replacement)
      end

      def clear(scope = :all)
      end
    end

    # Yields a singleton instance of Inflector::Inflections 
    # so you can specify additional inflector rules.
    def inflections
      if block_given?
        yield Inflections.instance
      else
        Inflections.instance
      end
    end

    def pluralize(word)
    end

    def singularize(word)
    end

    def humanize(lower_case_and_underscored_word)
    end

    def titleize(word)
    end

    def tableize(class_name)
    end

    def classify(table_name)
    end
  end
end
```

`ActiveSupport::Inflector::Inflections` class implements the singleton pattern. Singleton instance is returned or yielded by inflections method (defined in `ActiveSupport::Inflector` module) depending if it is called with a block or not. Methods like: `pluralize`, `singularize`, `humanize`, `titleize`, `tableize` and `classify` defined in `ActiveSupport::Inflector` module calls inflections method to get singleton instance and implement theirs functionality, and also `inflections` method is called in other parts of Rails like in `config/initializers/inflections.rb` with a block for adding other inflections that are not added by default:

```ruby
ActiveSupport::Inflector.inflections do |inflect|
  # inflect.plural /^(ox)$/i, '\1en'
  # inflect.singular /^(ox)en/i, '\1'
  # inflect.irregular 'person', 'people'
  # inflect.uncountable %w( fish sheep )
end
```

Feel free to point out to other interesting examples of the Singleton Pattern in Ruby?
