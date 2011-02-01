Feature: Manage comments
  In order to have cool comments
  As an editor
  I want to be able to manage comments

  Background:
    Given I am logged in as editor
    And a post exists
    And a comment exists with post: the post, name: "Pink Panter"

  Scenario: Admin can manage comments
    When I follow "Comments"
    And I follow "Pink Panter"
    And I follow "Edit"
    And I fill in "Content" with "Great Site"
    And I press "Save"
    Then I should see "Comment was successfully updated"
    And I should see "Great Site"

    When I follow "Delete"
    Then I should see "Comment was successfully destroyed"
    And I should not see "Bad Site"
