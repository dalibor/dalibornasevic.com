Feature: Admin comments
	In order to have cool comments
	As an administrator
	I want to filter bad comments

	Scenario: Admin lists comments in administration
		Given I am logged in
		And I have comments Cool site, Bad Site
		When I am on admin root page in administration
		When I follow "Comments"
		Then I should see "Cool site"
		And I should see "Bad Site"

	Scenario: Admin edits comments
		Given I have comments Cool site, Bad Site
		And I am logged in
		And I am on list of comments in administration
		And I click "Edit" "comment" "2" in "comments" block
		And I fill in the comment content "Great Site"
		And I press "Update"
		Then I should see "Comment was updated successfully"
		And I should see "Great Site"

	Scenario: Admin deletes comment
		Given I have comments Cool site, Bad Site
		And I am logged in
		And I am on list of comments in administration
		And I click "Delete" "comment" "2" in "comments" block
		When I press "Delete"
		Then I should see "Comment was deleted successfully"
		And I should not see "Bad Site"
		And I should have "1" comment