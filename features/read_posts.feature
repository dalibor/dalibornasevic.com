Feature: Display blog posts
  In order to read this blog
  As a visitor
  I want to be able to read posts

  Scenario: View list of posts
    Given Site has posts titled Cucumber, Webrat
    When I go to list of posts
    Then I should see "Cucumber"
    And I should see "Webrat"

  Scenario: View single post
    Given Site has posts titled Cucumber, Webrat
    When I go to list of posts
    And I follow "Webrat"
    Then I should see "Webrat"
    And I should not see "Cucumber"

  Scenario: Don't display unpublished posts
    Given Site has unpublished posts titled "Cucumber"
    When I go to list of posts
    Then I should not see "Cucumber"
