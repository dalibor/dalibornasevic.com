Feature: Manage editors
  In order to have editors
  As an admin
  I want to be able to manage editors

  Background:
    Given I am logged in as admin

  Scenario: Admin can create editors
    When I follow "Editors"
      And I follow "New"
      And I fill in "Name" with "New Editor"
      And I fill in "Email" with "new.editor@gmail.com"
      And I fill in "Password" with "password"
      And I fill in "Password confirmation" with "password"
      And I press "Save"
    Then I should see "Editor was successfully created"
      And I should see "New Editor"

    When I follow "Edit"
      And I fill in "Name" with "New Editor 2"
      And I press "Save"
    Then I should see "New Editor 2"

    When I follow "Delete"
    Then I should see "Editor was successfully destroyed"
      And I should not see "New Editor 2"




