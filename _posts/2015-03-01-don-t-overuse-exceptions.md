---
layout: post
title: "Don't Overuse Exceptions"
date: 2015-03-01 12:22:00 +0100
categories: [ruby, exceptions]
summary: "Never use exceptions to control flow."
permalink: /posts/52-don-t-overuse-exceptions
---

I like the following description for exceptions from the wiki-wiki article on [Don't Use Exceptions For Flow Control](http://c2.com/cgi/wiki?DontUseExceptionsForFlowControl) and we all know that GOTOs are [considered harmful](http://c2.com/cgi/wiki?GotoConsideredHarmful).

> Exceptions are like non-local goto statements.

Also, I mostly agree with these two statements from Joel Spolsky's article on [exceptions](http://www.joelonsoftware.com/items/2003/10/13.html). I think there are situations where raising exceptions on your own makes sense though.

> 1. Never throw an exception of my own.
> 2. Always catch any possible exception that might be thrown by a library I'm using on the same line as it is thrown and deal with it immediately. 

In *The Pragmatic Programmer*, Dave Thomas and Andy Hunt suggest:

> Ask yourself, "Will this code still run if I remove all the exception handlers?" If the answer is "no", then maybe exceptions are being used in non-exceptional circumstances.

User input is not something unexpected or exceptional. I often see that abused by using exceptions in validations. Sometimes as an alternative I see using multiple return values but that does not improve the situation because it's easy to forget the order or mix the values so best to avoid that too.

What leads to better design is replacing exceptions with notification in validations. Martin Fowler has an [article](http://martinfowler.com/articles/replaceThrowWithNotification.html) on the subject with some Java code samples. In Ruby/Rails, you get the same thing using [ActiveModel](https://github.com/rails/rails/tree/master/activemodel) validations.

```ruby
class Person
  include ActiveModel::Model

  attr_accessor :name
  validates_presence_of :name
end

person = Person.new
person.valid? # false
```

I would often use `ActiveModel::Validations` in combination with [`Virtus`](https://github.com/solnic/virtus) model for handling attributes when dealing with custom multiple models persistence or table-less models.

The first step in the process of switching from exceptions to notification in validations is figuring out the missing domain object to represent that logical entity in the system.
