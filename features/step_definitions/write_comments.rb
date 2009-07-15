Given /^site has post with id "([^\"]*)"$/ do |id|
  Factory.create(:post, :id => id)
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

When /^I fill in the comment content "([^\"]*)"$/ do |content|
  fill_in "Comments", :with => content
end

When /^I wait "([^\"]*)" second$/ do |time|
  original_value = Comment.minimum_wait_time
  Comment.minimum_wait_time = 1
  sleep Comment.minimum_wait_time
  @after_current_scenario_blocks << lambda{ Comment.minimum_wait_time = original_value } 
end