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
    And this comment is not spam
    And I press "Comment"
    Then I should see "Your comment was successfully created."
    And I should see "My first comment"

  Scenario: Try to create spam comment
    When I fill in "Name" with "Spammer"
    And I fill in "Email" with "spammer@gmail.com"
    And I fill in "URL" with "http://www.spammer.com"
    And I fill in "Comment" with "My first spam comment"
    And this comment is spam
    And I press "Comment"
    Then I should see "Unfortunately this comment is considered spam by Akismet. It will show up once it has been approved by the administrator."

  Scenario: Try to create invalid comment
    When I fill in "Name" with "Dalibor"
    And I press "Comment"
    Then I should see "There were problems with the following fields"
