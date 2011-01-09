require "yaml"

file = YAML.load_file(File.join(Rails.root, 'config/application.yml'))

USERNAME = file['password']['username']
PASSWORD = file['password']['password']
REALM = file['password']['realm']

BLOG_URL = file['blog']['url']
BLOG_TITLE = file['blog']['title']
BLOG_DESCRIPTION = file['blog']['description']
BLOG_KEYWORDS = file['blog']['keywords']
BLOG_FOOTER = file['blog']['footer']
BLOG_ABOUT_SHORT = file['blog']['about']['short']
BLOG_ABOUT_LONG = file['blog']['about']['long']

RSS_TITLE = file['rss']['title']
RSS_DESCRIPTION = file['rss']['description']

LASTFM_USERNAME = file['lastfm']['username']
LASTFM_NUMBER_OF_TRACKS = file['lastfm']['number_of_tracks'].to_i
LASTFM_SERVICE_UNAVAILABLE_MESSAGE = file['lastfm']['service_unavailable_message']

TWITTER_USERNAME = file['twitter']['username']
TWITTER_NUMBER_OF_TWITS = file['twitter']['number_of_twits'].to_i
TWITTER_SERVICE_UNAVAILABLE_MESSAGE = file['twitter']['service_unavailable_message']


GOOGLE_ANALYTICS_ID = file['google']['analytics_id']

Rakismet::KEY  = file['akismet']['key']
Rakismet::URL  = file['akismet']['url']
Rakismet::HOST = file['akismet']['host']
