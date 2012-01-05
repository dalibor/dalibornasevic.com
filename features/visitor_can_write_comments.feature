Feature: A visitor can write comments
  In order to comment on a post
  As a visitor
  I want to be able to write comments

  Background:
    Given a post exists with title: "Cucumber"
    When I am on list of posts
    And I follow "Cucumber"

  Scenario: Create new comment
    When I fill in "Name" with "Dalibor"
    And I fill in "Email" with "dalibor.nasevic@gmail.com"
    And I fill in "URL" with "http://www.dalibornasevic.com"
    And I fill in "Comment" with "My first comment"
    And I press "Comment"
    Then I should see "Thanks for commenting!"
    And I should see "My first comment"

  Scenario: See comment errors
    When I press "Comment"
    Then the page should have css selector ".field_with_errors #comment_name"
    Then the page should have css selector ".field_with_errors #comment_email"
    And the page should have css selector ".field_with_errors #comment_content"
