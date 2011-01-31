Feature: Manage blog posts
  In order to have good posts
  As an editor
  I want to be able to manage posts

  Scenario: Admin lists posts in administration
    Given I am logged in
    When I follow "Administration"
    When I follow "Posts"
    And I follow "Create new"
    And I fill in "Title" with "First title"
    And I fill in "Content" with "First content"
    And I check "post_publish"
    And I fill in "Tags" with "Tag1 Tag2 Tag3"
    And I press "Create"
    Then I should see "Post was created successfully"

    When I am on list of posts in administration
    And I follow "Edit"
    And I fill in "Title" with "Git"
    And I fill in "Content" with "Git rules"
    And I press "Update"
    Then I should see "Post was updated successfully"
    And I should see "Git"
    And I should not see "Cucumber"

    And I am on list of posts in administration
    And I follow "Delete"
    When I press "Delete"
    Then I should see "Post was deleted successfully"
    And I should not see "Git"

