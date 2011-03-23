// remap jQuery to $
(function ($) {

  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  $('#tweets_container').tweets({username: 'blackflasher', limit: 3});
  $('#tracks_container').tracks({username: 'blackflasher', limit: 3});

})(this.jQuery);
