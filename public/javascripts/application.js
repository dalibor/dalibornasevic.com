// remap jQuery to $
(function ($) {

  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  //$('body').noisy({
      //intensity: 0.9, 
      //size: 200, 
      //opacity: 0.08,
      ////fallback: 'fallback.png',
      //monochrome: false
  //});

  $('#tweets_container').tweets({username: 'blackflasher', limit: 3});
  $('#tracks_container').tracks({username: 'blackflasher', limit: 3});

})(this.jQuery);
