require "yaml"

file = YAML.load_file(File.join(RAILS_ROOT, 'config/application.yml'))

USERNAME = file['password']['username']
PASSWORD = file['password']['password']
REALM = file['password']['realm']

BLOG_TITLE = file['blog']['title']

RSS_TITLE = file['rss']['title']
RSS_DESCRIPTION = file['rss']['description']

LASTFM_USERNAME = file['lastfm']['username']
LASTFM_NUMBER_OF_TRACKS = file['lastfm']['number_of_tracks'].to_i
LASTFM_SERVICE_UNAVAILABLE_MESSAGE = file['lastfm']['service_unavailable_message']

TWITTER_USERNAME = file['twitter']['username']
TWITTER_NUMBER_OF_TWITS = file['twitter']['number_of_twits']
TWITTER_SERVICE_UNAVAILABLE = file['twitter']['service_unavailable_message']


GOOGLE_ANALYTICS_ID = file['google']['analytics_id']