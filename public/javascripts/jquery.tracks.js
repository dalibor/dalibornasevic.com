/**
 *
 * Gets recent tracks from Last.fm JSON API
 *
 * Dependencies:
 *
 * jquery              - http://jquery.com/
 * jquery-timeago.js   - https://github.com/rmm5t/jquery-timeago
 * jquery-autolink.js  - http://kawika.org/jquery/js/jquery.autolink.js
 *
 * Usage:
 *
 *  - include: jquery-1.4.4.min.js, jquery.timeago.js, jquery.autolink.js, jquery.tracks.js
 *
 *  $(function () {
 *    $('#tracks').tracks({username: 'blackflasher', limit: 3});
 *  });
 *
 * TODO:
 *
 *  - loading notification
 *  - autorefresh
 *
 */

(function ($) {

  var Lastfm = (
    function () {
      var tracks = function (settings, container) {
        var url = 'http://ws.audioscrobbler.com/2.0/?' +
                  'format=json&callback=?&' +
                  'method=user.getrecenttracks&' +
                  'api_key=' + settings.apiKey +
                  '&user=' + settings.username +
                  '&limit=' + settings.limit;

        $.getJSON(url, function (data) {
          container.append(draw(data));
        });
      };

      var draw = function (data) {
        var ul = $('<ul/>');
        var url;
        var listeningNow;

        $.each(data.recenttracks.track, function (i) {
          var liClass = (i % 2 === 0) ? 'odd' : 'even';
          var li;

          if (this.image[0]['#text'] !== '') {
            var imageUrl = this.image[0]['#text']
          } else {
            var imageUrl = 'http://cdn.last.fm/flatness/catalogue/noimage/2/default_artist_small.png'
          }

          li = $('<li/>', {'class': liClass}).append(
            $('<img/>').attr({'class': 'cover', src: imageUrl, 
              alt: this.album['#text'], title: this.album['#text']}),
            $('<div/>').append(
              this.artist['#text'] + ' - ',
              $('<a/>').attr({href: this.url, target: '_blank'}).text(this.name)
            )
          )

          if (typeof(this.date) === 'undefined') {
            li.append(
              $('<div/>').attr({'class': 'listening_now'}).append(
                $('<img/>').attr({src: 'http://cdn.last.fm/flatness/global/icon_eq.gif'}),
                'Listening now'
              )
            )
          } else {
            li.append(
              $('<i/>').attr({title: this.date['#text'], 'class': 'date'}).timeago())
          }

          ul.append(li)
        });

        return ul;
      }

      return {
        tracks: tracks
      }
    }()
  );

  $.fn.tracks = function(options){
    return this.each(function () {
      var defaults = {
        limit: 5,
        username: 'blackflasher',
        apiKey: 'b25b959554ed76058ac220b7b2e0a026'
      }

      settings = $.extend({}, defaults, options);

      Lastfm.tracks(settings, $(this));
    });
  }

})(jQuery);
