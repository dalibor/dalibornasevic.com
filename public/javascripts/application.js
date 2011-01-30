var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));

function startAnalytics(id) {
  try {
    var pageTracker = _gat._getTracker(id);
    pageTracker._trackPageview();
  } catch(err) {}
}

$(function () {
  SyntaxHighlighter.defaults['toolbar'] = false;
  SyntaxHighlighter.all();

  if (typeof(_google_analytics_id) != "undefined" && _google_analytics_id){
    startAnalytics(_google_analytics_id);
  }

  $('#tweets').tweets({username: 'blackflasher', limit: 3});
  $('#lastfm').tracks({username: 'blackflasher', limit: 3});
});
