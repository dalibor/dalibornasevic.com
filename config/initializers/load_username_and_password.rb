require "yaml"

file = YAML.load_file(File.join(RAILS_ROOT, 'config/password.yml'))

USERNAME = file['password']['username']
PASSWORD = file['password']['password']
