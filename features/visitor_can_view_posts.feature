Feature: A visitor can view posts
  In order to read the blog
  As a visitor
  I want to be able to view posts

  Scenario: View list of posts
    Given a post exists with title: "Cucumber"
    And a post exists with title: "Webrat"
    When I am on list of posts
    Then I should see "Cucumber"
    And I should see "Webrat"

  Scenario: View single post
    Given a post exists with title: "Cucumber"
    And a post exists with title: "Webrat"
    When I am on list of posts
    And I follow "Webrat"
    Then I should see "Webrat"
    And I should not see "Cucumber"

  Scenario: Don't display unpublished posts
    Given a post exists with title: "Cucumber", published_at: nil
    When I am on list of posts
    Then I should not see "Cucumber"
