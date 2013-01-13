// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require 'syntaxhighlighter/shCore'
//= require 'syntaxhighlighter/shBrushDiff.js'
//= require 'syntaxhighlighter/shBrushPlain.js'
//= require 'syntaxhighlighter/shBrushRuby'
//= require 'syntaxhighlighter/shBrushBash.js'
//= require 'syntaxhighlighter/shBrushCss.js'
//= require 'syntaxhighlighter/shBrushSass.js'
//= require 'syntaxhighlighter/shBrushJScript.js'
//= require 'syntaxhighlighter/shBrushXml.js'
//= require 'syntaxhighlighter/shBrushVimscript.js'

$(function () {
  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();
});
