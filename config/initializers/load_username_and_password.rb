require "yaml"

file = YAML.load_file(File.join(RAILS_ROOT, 'config/password.yaml'))

USERNAME = file['password']['username']
PASSWORD = file['password']['password']
