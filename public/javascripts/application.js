// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));

function startAnalytics(id) {
  try {
    var pageTracker = _gat._getTracker(id);
    pageTracker._trackPageview();
  } catch(err) {}
}
  
document.observe('dom:loaded', function(){

  
  if (!_google_analytics_id.blank()){
    startAnalytics(_google_analytics_id);
  }

  if ($('notice')){
      new Effect.Fade($('notice'), {
      });
  }
  
  if ($('error')){
      new Effect.Fade($('error'), {
      });
  }
  
  if ($('lastfm_content')){
    new Ajax.PeriodicalUpdater({ success: 'lastfm_content' }, '/services/lastfm', {
      method: 'get',
      frequency: 300, decay: 2,
      parameters: { authenticity_token: encodeURIComponent( _token ) },
      onLoading: function(){
        $('lastfm_loading').show();
        $('lastfm_content').hide();
      },
      onSuccess: function(){
        $('lastfm_loading').hide();
        $('lastfm_content').show();
      },
      onFailure: function(transport){
        $('lastfm_content').update(transport.responseText);
        $('lastfm_loading').hide();
        $('lastfm_content').show();
      }
    });
  }
  
  if ($('twitter_content')){
    new Ajax.PeriodicalUpdater({ success: 'twitter_content' }, '/services/twitter', {
      method: 'get',
      frequency: 600, decay: 2,
      parameters: { authenticity_token: encodeURIComponent( _token ) },
      onLoading: function(){
        $('twitter_loading').show();
        $('twitter_content').hide();
      },
      onSuccess: function(){
        $('twitter_loading').hide();
        $('twitter_content').show();
      },
      onFailure: function(transport){
        $('twitter_content').update(transport.responseText);
        $('twitter_loading').hide();
        $('twitter_content').show();
      }
    });
  }
});
