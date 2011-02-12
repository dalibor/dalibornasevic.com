# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'ruby-debug'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end

def login_as_editor
  current_editor = Factory.create(:editor, :email => "editor@example.com")
  controller.stub!(:current_editor).and_return(current_editor)
  controller.stub!(:authenticate).and_return(:true)
  current_editor
end

def login_as_admin
  current_editor = Factory.create(:admin, :email => "admin@example.com")
  controller.stub!(:current_editor).and_return(current_editor)
  controller.stub!(:authenticate).and_return(:true)
  current_editor
end

shared_examples_for "protected resource" do
  it "should protect resource" do
    flash[:alert].should_not be_nil
    response.should be_redirect
  end
end

shared_examples_for "accessible resource" do
  it "should protect resource" do
    flash[:alert].should be_nil
  end
end
