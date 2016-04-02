source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'virtus'

# markdown to html
gem 'github-markup', '= 1.2.1'
gem 'github-markdown', '= 0.6.6'
gem 'github-linguist', '= 3.1.1'
gem 'html-pipeline', '= 1.9.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'uglifier'
  gem 'compass-rails'
  gem 'compass-h5bp'
  gem 'compass', '~> 0.12.alpha.0'
end

group :development do
  gem 'thin'
  gem 'gitploy'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.1'
  gem 'quiet_assets'
  gem 'html5-rails'
end

group :test do
  gem 'poltergeist'
  gem 'capybara'
  gem 'launchy', '= 2.1.0'
end
