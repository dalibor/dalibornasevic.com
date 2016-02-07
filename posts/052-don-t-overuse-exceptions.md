---
id: 52
title: "Don't Overuse Exceptions"
date: 2015-03-01 12:22:00 +0100
author: Dalibor Nasevic
tags: [ruby, exceptions]
---

> Exceptions are like non-local goto statements.

I like this description a lot from the wiki-wiki article on [Don't Use Exceptions For Flow Control](http://c2.com/cgi/wiki?DontUseExceptionsForFlowControl). And, we all know that GOTOs are [considered harmful](http://c2.com/cgi/wiki?GotoConsideredHarmful).

Also, I cannot agree more with these 2 statements from Joel Spolsky in his article on [exceptions](http://www.joelonsoftware.com/items/2003/10/13.html):

> 1. Never throw an exception of my own.
> 2. Always catch any possible exception that might be thrown by a library I'm using on the same line as it is thrown and deal with it immediately. 

Most of the situations where I've seen exceptions being improperly used is when there is some sort of a validation. And, usually it ends up with a giant method that rescues different exceptions and sets some sort of a status and/or return value.

The problem is with reuse of the code under rescue in different contexts. It's easy to forget that it raises an exception and it becomes a mess to deal with those exceptions in different places.

As an alternative to exceptions I often see multiple return values. They don't really improve the situation and it's easy to forget the order or mix the values, so best to avoid it.

What I do like is replacing exceptions with notification in validations. Martin Fowler has an [article](http://martinfowler.com/articles/replaceThrowWithNotification.html) on the subject with some Java code samples. In Ruby/Rails, you get the same thing using [ActiveModel](https://github.com/rails/rails/tree/master/activemodel) validations.

```ruby
class Person
  include ActiveModel::Model

  attr_accessor :name
  validates_presence_of :name
end

person = Person.new
person.valid? # false
```

I would often just use `ActiveModel::Validations` in combination with [Virtus](https://github.com/solnic/virtus) model (for the attributes) to deal with multiple models persistence or table-less model using just PORO objects. The first step is always figuring out the missing domain object to represent that logical entity.

In *The Pragmatic Programmer*, Dave Thomas and Andy Hunt suggest:

> Ask yourself, "Will this code still run if I remove all the exception handlers?" If the answer is "no", then maybe exceptions are being used in non-exceptional circumstances.

User input is not something unexpected or exceptional, so don't overuse exceptions.
