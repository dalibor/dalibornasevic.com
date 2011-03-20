/**
 *
 * Gets latest tweets from Twitter JSON API
 *
 * Dependencies:
 *
 * jquery              - http://jquery.com/
 * jquery-timeago.js   - https://github.com/rmm5t/jquery-timeago
 * jquery-autolink.js  - http://kawika.org/jquery/js/jquery.autolink.js
 *
 * Usage:
 *
 *  - include: jquery-1.4.4.min.js, jquery.timeago.js, jquery.autolink.js, jquery.tweets.js
 *
 *  $(function () {
 *    $('#tweets').tweets({username: 'blackflasher', limit: 3});
 *  });
 *
 * TODO:
 *
 *  - loading notification
 *  - autorefresh
 *
 */

(function ($) {

  var Twitter = (
    function () {
      var twitterUrl = 'http://twitter.com/';

      var tweets = function (settings, container) {
        var url = twitterUrl + 'statuses/user_timeline/' + settings.username +
                  '.json?callback=?&count=' + settings.limit;
        $.getJSON(url, function (data) {
          container.append(draw(data));
        });
      };

      var draw = function (data) {
        var ul = $('<ul/>');
        var liClass;
        var url;

        $.each(data, function (i) {
          liClass = (i === 0) ? "odd" : "even";
          url = twitterUrl + this.user.screen_name + '/status/' + this.id_str;

          ul.append(
            $("<li/>", {"class": liClass}).append(
              $('<div/>').text(this.text).autolink(),
              $('<i/>').append(
                $('<a/>').attr({href: url, title: this.created_at,
                  "class": "date", target: '_blank'}).timeago()
              )
            )
          )
        });

        return ul;
      }

      return {
        tweets: tweets
      }
    }()
  );

  $.fn.tweets = function (options) {
    return this.each(function () {
      var defaults = {
        limit: 5,
        username: 'blackflasher'
      };

      settings = $.extend({}, defaults, options);

      Twitter.tweets(settings, $(this));
    });
  }

})(jQuery);
