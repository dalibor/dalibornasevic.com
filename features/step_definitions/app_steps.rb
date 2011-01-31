Given /^I am logged in$/ do
  steps %Q{
    Given I am on the login page
    When I fill in "Email" with "pink.panter@gmail.com"
    And I fill in "Password" with "password"
    And I press "Login"
  }
end

Given /^I am logged in as editor$/ do
  Factory.create(:editor)
  Given "I am logged in"
end

Given /^I am logged in as admin$/ do
  Factory.create(:editor, :is_admin => true)
  Given "I am logged in"
end

Given /^I have posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end

Then /^should see a comment form$/ do
  response.should have_selector("form#new_comment")
#  response.should field_element("comment[email]")
  response.should have_xpath(".//input[@name = 'comment[name]']" )
  response.should have_xpath(".//input[@name = 'comment[email]']" )
  response.should have_xpath(".//textarea[@name = 'comment[content]']" )
  response.should have_xpath(".//input[@name = 'commit' and @type = 'submit' and @value = 'Comment']" )
end

When /^I fill in the comment name "([^\"]*)"$/ do |name|
  fill_in "Name", :with => name
end

When /^I fill in the comment email "([^\"]*)"$/ do |email|
  fill_in "Email", :with => email
end

When /^I fill in the comment url "([^\"]*)"$/ do |url|
  fill_in "URL", :with => url
end

When /^this comment is not spam$/ do
  class Comment
    def spam?
      false
    end
  end
end

When /^this comment is spam$/ do
#  Rakismet::KEY.stub!(:blank?).and_return(false)
  module Rakismet;  remove_const :"KEY"; end
  Rakismet::KEY = '1234567890'
  class Comment
    def spam?
      true
    end
  end
end

#When /^I wait "([^\"]*)" second$/ do |time|
#  now = Time.now
#  Time.stub!(:now).and_return(now + time.to_i.seconds)

#  original_value = Comment.minimum_wait_time
#  Comment.minimum_wait_time = 1
#  sleep Comment.minimum_wait_time
#  @after_current_scenario_blocks << lambda{ Comment.minimum_wait_time = original_value }
#end
