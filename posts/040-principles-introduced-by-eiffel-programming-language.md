---
id: 40
title: "Principles introduced by Eiffel programming language"
date: 2013-04-04 22:11:00 +0200
author: Dalibor Nasevic
tags: [OO, design, principles, eiffel]
summary: "Overview of few important principles introduced by the Eiffel programming language."
---

[**Eiffel**](http://en.wikipedia.org/wiki/Eiffel_(programming_language) "Eiffel programming language") is an object-oriented programming language designed by Bertrand Meyer in 1986. It didn't gain much popularity, but it introduced few important programming principles that had big impact and later found their way into other programming languages. So, I thought I would introduce some of them briefly in here.

### 1. [Design by contract (DbC)](http://en.wikipedia.org/wiki/Design_by_contract "Design by contract (DbC)")

**DbC** is a metaphor on how elements of a software system collaborate with each other, on the basis of mutual obligations and benefits. It means that when defining a method we are actually signing a contract between the caller and the method with the following responsibilities:

- caller ensures that preconditions of the method are met (correct inputs)
- method ensures that postcondiions are met (correct outputs and side effects) and invariants are met (object is left in a consistent state)

Thinking about contracts when defining methods is about deciding which contracts to sign. Of course, those that are in our favor: small, precise and strict.

### 2. [Command–query separation (CQS)](http://en.wikipedia.org/wiki/Command-query_separation "Command–query separation (CQS)")

Every method should either perform action - **command**  or return data to the caller - **query** . The idea is to separate methods in two categories:

- queries: methods that return value but does not change state or cause any side efects
- commands: methods that change the state of the system but does not return value

Having a method that does both command and query is a good sign for refactoring to separate the two.

### 3. [Uniform access principle (UAP)](http://en.wikipedia.org/wiki/Uniform_access_principle "Uniform access principle (UAP)")

All services offered by a module should be available through a uniform notation, which does not betray whether they are implemented through storage or through computation. It means that there should not be a different notation for accessing an attribute and method or query. As an example would be object attributes in Ruby which satisfy this principle for both getter and setter values. Other example is Java which does not support this natively because the syntax is different for instance variables and functions accessing them (convention is that accessor methods include get/set prefix).

### 4. [Single Choice Principle (SCP)](http://en.wikipedia.org/wiki/Single_choice_principle "Single Choice Principle (SCP)")

The exhaustive list of alternatives should live in exactly one place. This principle was later formulated by Andy Hunt and Dave Thomas as [Don't Repeat Yourself](http://en.wikipedia.org/wiki/Don't_repeat_yourself "Don't Repeat Yourself") (DRY) principle in "The Pragmatic Programmer" book. It states that: Every piece of knowledge must have a single, unambiguous, authoritative representation within a system. DRY principle is not about typing, but it is about not duplicating concepts and isolating change. If you have to change something in more than one place, then it's not DRY.

### 5. [Open/Closed Principle (OCP)](http://en.wikipedia.org/wiki/Open_Closed_Principle "Open/Closed Principle (OCP)")

Software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification. The idea is that once completed, the implementation of a class should only be modified to correct errors. New or changed features would require that a different class is created. That class could use the original class but it should not require change in it.

While these principles might look abstract at first, understanding them could change the way you think about software design.
