---
layout: post
title: "Javascript Development Tips"
date: 2010-02-05 00:45:00 +0100
categories: [javascript, benchmark, debug]
summary: "Totally random Javascript development tips."
permalink: /posts/10-javascript-development-tips
---

I'm working on live betting system written in Javascript and jQuery. It consumes two APIs (Search and POS API) and has some complex functionality. So, time has come to tag something with Javascript on my blog.

The first tip is about benchmarking and second about debugging Javascript code using the console functionality. I use Firefox and Firebug for web development.

Benchmarking Javascript code using Firebug is really easy, You just drop console.time at the beginning and console.timeEnd at the end of the code snippet, and then you get result about how that code is performing:

```javascript
console.time('BEFORE');
var ar = [];
for (i = 0; i < 10000; i++) {
  ar.push("text");
}
ar.join("");
console.timeEnd('BEFORE');

console.time('AFTER');
var str = "";
for (i = 0; i < 10000; i++) {
  str += "text"
}
console.timeEnd('AFTER');
```

The results are:

```javascript
BEFORE: 16ms
AFTER: 13ms
```

The second tip is about cross-browser Javascript debugging by logging debug messages. I get this tip from [Secrets of the JavaScript Ninja](http://jsninja.com/ "Secrets of the JavaScript Ninja book") book, but improved it a little bit by encapsulating it in a module using the [Javascript module pattern](http://www.yuiblog.com/blog/2007/06/12/module-pattern/ "Javascript module pattern") and adding some [JS Lint](http://www.jslint.com/ "JS Lint") code quality check.

```javascript
/*global console */
/*global opera */

"use strict";

/**
 * Logger functionality
 * @constructor
 */
var LOGGER = (
  function () {

    /**
     * Writes log messages
     * 
     */
    function log() {
      try {
        console.log.apply(console, arguments);
      } catch (e) {
        try {
          opera.postError.apply(opera, arguments);
        } 
        catch (e2) {
        alert( Array.prototype.join.call( arguments, " " ) );
        }
      }
    }

    /**
     * Public interface
     * 
     */
    return {
      log: log
    };
  }()
);
```

Then we can use this module and log some messages:

```javascript
LOGGER.log("message 1")
LOGGER.log("message 2")
```

If you like more fancy way of logging messages you may want to check the [Blackbird](http://www.gscottolson.com/blackbirdjs/ "Blackbird message logging library") library.

Next on Javascript I will be writing on some Javascript tools for code quality check, documenting code, code compression, etc.
