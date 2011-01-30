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
        var liClass;
        var url;
        var date;
        var listeningNow;

        $.each(data.recenttracks.track, function (i) {
          liClass = (i === 0) ? "odd" : "even";

          if (typeof(this.date) === "undefined") {
            date = '';
            listeningNow = $('<span/>').append(
              $('<img/>').attr({src: 'http://cdn.last.fm/flatness/global/icon_eq.gif'}),
              'Listening now'
            )
          } else {
            date = this.date['#text'];
            listeningNow = '';
          }

          if (this.image[0]['#text'] !== '') {
            var imageUrl = this.image[0]['#text']
          } else {
            var imageUrl = 'http://cdn.last.fm/flatness/catalogue/noimage/2/default_artist_small.png'
          }

          ul.append(
            $("<li/>", {"class": liClass}).append(
              $('<span/>').append(
                $('<img/>').attr({src: imageUrl, alt: this.album['#text'], title: this.album['#text']})
              ),
              $('<span/>').append(
                this.artist['#text'] + ' - ',
                $('<a/>').attr({href: this.url, target: '_blank'}).text(this.name)
              ),
              $('<span/>').attr({title: date}).timeago(),
              listeningNow
            )
          )
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
        apiKey: 'b25b959554ed76058ac220b7b2e0a026',
      },
      settings = $.extend({}, defaults, options);

      Lastfm.tracks(settings, $(this));
    });
  }

})(jQuery);
