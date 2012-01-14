Feature: Editor can edit profile
  In order to change my profile
  As an editor
  I want to be able to edit my profile

  Scenario: Editor can edit profile
    Given I am logged in as editor
    When I follow "Profile"
      And I fill in "Name" with "My new name"
      And I fill in "Email" with "my_new_email@gmail.com"
      And I fill in "Password" with "password2"
      And I fill in "Password confirmation" with "password2"
      And I press "Save"
    Then I should see "Profile was successfully updated"

    When I follow "Logout"
      And I fill in "Email" with "my_new_email@gmail.com"
      And I fill in "Password" with "password2"
      And I press "Login"
    Then I should see "Logged in!"


