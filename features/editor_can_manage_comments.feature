Feature: Manage comments
  In order to have cool comments
  As an editor
  I want to be able to manage comments

  Scenario: Editor can manage comments
    Given an editor exists with email: "editor@example.com"
    And a post exists with editor: the editor
    And a comment exists with post: the post, name: "Pink Panter"
    And I am logged in as "editor@example.com"
    When I follow "Comments"
    Then show me the page
    And I follow "Pink Panter"
    And I follow "Edit"
    And I fill in "Content" with "Great Site"
    And I press "Save"
    Then I should see "Comment was successfully updated"
    And I should see "Great Site"

    When I follow "Delete"
    Then I should see "Comment was successfully destroyed"
    And I should not see "Bad Site"

  Scenario: Editor can view only their comments
    Given an editor exists with email: "i_the_editor@example.com"
    And a post exists with editor: the editor, title: "My post"
    And a comment exists with post: the post, name: "Commenter 1"
    And an editor exists with email: "other_editor@example.com"
    And a post exists with editor: the editor, title: "Other post"
    And a comment exists with post: the post, name: "Commener 2"
    And I am logged in as "i_the_editor@example.com"
    When I follow "Comments"
    Then I should see "Commenter 1"
    Then I should not see "Commenter 2"
