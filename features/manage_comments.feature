Feature: Admin comments
  In order to have cool comments
  As an administrator
  I want to filter bad comments

  Background:
    Given I am logged in
    And a post exists
    And a comment exists with post: the post, content: "Cool site"
    And a comment exists with post: the post, content: "Bad Site"

  Scenario: Admin lists comments in administration
    When I am on admin root page in administration
    And I follow "Comments"
    Then I should see "Cool site"
    And I should see "Bad Site"

  @wip
  Scenario: Admin edits comments
    When I am on list of comments in administration
    And I follow to edit comment "2"
    And I fill in the comment content "Great Site"
    And I press "Update"
    Then I should see "Comment was updated successfully"
    And I should see "Cool Site"
    And I should see "Great Site"

  @wip
  Scenario: Admin deletes comment
    When I am on list of comments in administration
    And I follow to delete comment "2"
    When I press "Delete"
    Then I should see "Comment was deleted successfully"
    And I should not see "Bad Site"
