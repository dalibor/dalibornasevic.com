Given /^I am logged in as "([^\"]*)"$/ do |email|
  steps %Q{
    Given I am on the login page
    When I fill in "Email" with "#{email}"
    And I fill in "Password" with "password"
    And I press "Login"
  }
end

Given /^I am logged in as editor$/ do
  Factory.create(:editor, :email => "editor@example.com")
  steps %Q{
    Given I am logged in as "editor@example.com"
  }
end

Given /^I am logged in as admin$/ do
  Factory.create(:editor, :is_admin => true, :email => "pink.panter@gmail.com")
  steps %Q{
    Given I am logged in as "pink.panter@gmail.com"
  }
end

Then /^the page should have css selector "([^"]*)"$/ do |selector|
  page.should have_css(selector)
end

Then /^the page should match "([^"]*)"$/ do |src|
  page.body.should match(src)
end
