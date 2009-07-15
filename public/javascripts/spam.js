var wait_seconds = 15
 
$(document).observe('dom:loaded', function() {
  // disable the form
  disable_comment_form()
  // update the form
  new PeriodicalExecuter(function(pe) {
    // if we find our form
    if(el = $('new_comment')) {
      // decrement the seconds
      wait_seconds = wait_seconds - 1
    
      var button = el.down('input.submit')
    
      // if there is time left
      if(wait_seconds > 0) {
        // simply update the text
        button.value = 'Please wait ' + wait_seconds + ' seconds...'
      } else {
        // stop the future events
        pe.stop();
        // update the text
        button.value = 'Comment'
        // enable it
        button.disabled = ''
      }
    // if we can't find the form
    } else {
      // stop the future events
      pe.stop();
    }
  }, 1)
})
 
var disable_comment_form = function() {
  if(el = $('new_comment')) {
    var button = el.down('input.submit')
    button.value = 'Please wait ' + wait_seconds + ' seconds...'
    button.disabled = 'disabled'
  }
}