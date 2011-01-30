require "yaml"

file = YAML.load_file(File.join(Rails.root, 'config/application.yml'))
B = {}

USERNAME = file['password']['username']
PASSWORD = file['password']['password']
REALM = file['password']['realm']

B[:url]         = file['blog']['url']
B[:title]       = file['blog']['title']
B[:description] = file['blog']['description']
B[:keywords]    = file['blog']['keywords']

Rakismet::KEY   = file['akismet']['key']
Rakismet::URL   = file['akismet']['url']
Rakismet::HOST  = file['akismet']['host']
