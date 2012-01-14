Feature: Manage blog posts
  In order to have good posts
  As an editor
  I want to be able to manage posts

  Scenario: Editor lists posts in administration
    Given I am logged in as editor
    When I follow "Posts"
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

  Scenario: Editor can view only their posts
    Given an editor exists with email: "i_the_editor@example.com"
      And a post exists with editor: the editor, title: "My post"
      And an editor exists with email: "other_editor@example.com"
      And a post exists with editor: the editor, title: "Other post"
      And I am logged in as "i_the_editor@example.com"
    When I follow "Posts"
    Then I should see "My post"
      And I should not see "Other post"
