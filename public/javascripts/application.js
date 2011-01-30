
// remap jQuery to $
(function ($) {

  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  $('#tweets').tweets({username: 'blackflasher', limit: 3});
  $('#lastfm').tracks({username: 'blackflasher', limit: 3});

})(this.jQuery);
