Feature: Manage comments
  In order to have cool comments
  As an editor
  I want to be able to manage comments

  Background:
    Given I am logged in
    And I follow "Administration"
    And a post exists
    And a comment exists with post: the post, content: "Bad Site"

  Scenario: Admin lists comments in administration
    When I am on admin root page in administration
    And I follow "Comments"
    Then I should see "Bad Site"

  Scenario: Admin edits comments
    When I am on list of comments in administration
    And I follow "Edit"
    And I fill in the comment content "Great Site"
    And I press "Update"
    Then I should see "Comment was updated successfully"
    And I should see "Great Site"

  @run
  Scenario: Admin deletes comment
    When I am on list of comments in administration
    And I follow "Delete"
    Then I should see "Comment was deleted successfully"
    And I should not see "Bad Site"
