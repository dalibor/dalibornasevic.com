Feature: Display blog posts
 In order to track user's blog activities and posts
 As a visitor
 I want to be able to read blog posts

  Scenario: View list of blog posts
    Given Site has posts titled Cucumber, Webrat
    When I go to list of blog posts
    Then I should see "Cucumber"
    And I should see "Webrat"

  Scenario: View single blog post
    Given Site has posts titled Cucumber, Webrat
    When I go to list of blog posts
    And I follow "Webrat"
    Then I should see "Webrat"
    And I should not see "Cucumber"
