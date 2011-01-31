Feature: Manage blog posts
  In order to have good posts
  As an editor
  I want to be able to manage posts

  Scenario: Admin lists posts in administration
    Given I am logged in as editor
    When I follow "Administration"
    And I follow "Posts"
    And I follow "New"
    And I fill in "Title" with "First title"
    And I fill in "Content" with "First content"
    And I check "post_publish"
    And I fill in "Tags" with "tag1 tag2 tag3"
    And I press "Save"
    Then I should see "Post was successfully created"

    When I follow "Edit"
    And I fill in "Title" with "Git"
    And I fill in "Content" with "Git rules"
    And I press "Save"
    Then I should see "Post was successfully updated"
    And I should see "Git"
    And I should not see "Cucumber"

    When I follow "Delete"
    Then I should see "Post was successfully destroyed"
    And I should not see "Git"
