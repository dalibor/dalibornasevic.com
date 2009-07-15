# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures
Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling 
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

Before do
  @after_current_scenario_blocks = []
  
  class ApplicationController
    def authenticate
      authenticate_or_request_with_http_basic(REALM) do |username, password|
        username == USERNAME && password == PASSWORD
      end
    end
  end
end

After do
 if @after_current_scenario_blocks.any?
   @after_current_scenario_blocks.each{ |b| b.call }
 end
end 