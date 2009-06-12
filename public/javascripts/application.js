// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

document.observe('dom:loaded', function(){
  
  if ($('notice')){
      new Effect.Fade($('notice'), {
        delay: 3
      });
  }
  
  if ($('error')){
      new Effect.Fade($('error'), {
        delay: 3
      });
  }
  
//    var body = document.getElementsByTagName("body")[0];
//    script = document.createElement('script');
//    script.type = 'text/javascript';
//    script.src = "http://twitter.com/javascripts/blogger.js";
//    body.appendChild(script);
    
//    script2 = document.createElement('script');
//    script2.type = 'text/javascript';
//    script2.src = "http://twitter.com/statuses/user_timeline/blackflasher.json?callback=twitterCallback2&amp;count=3";
//    body.appendChild(script2);



});
