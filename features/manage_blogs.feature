Feature: Manage Blog posts
  In order to make a blog
  As an author
  I want to create and manage blog posts

  Scenario: Blog posts list
    Given I have posts titled Cucumber, Webrat, Vim, Git
    When I go to list of articles
    Then I should see "Cucumber"
    And I should see "Webrat"
    And I should see "Vim"
    And I should see "Git"
