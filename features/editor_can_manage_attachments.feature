Feature: Manage attachments
  In order to have attachments
  As an editor
  I want to be able to manage attachments

  Scenario: Editor lists attachments in administration
    Given I am logged in as editor
    When I follow "Attachments"
    And I follow "New"
    And I fill in "Name" with "Attachment1"
    And I attach the file "spec/fixtures/rails1.png" to "Attachment"
    And I press "Save"
    Then I should see "Attachment was successfully created"
    And I should see "Attachment1"
    And the page should match "rails1.png"

    When I follow "Edit"
    And I fill in "Name" with "Attachment2"
    And I attach the file "spec/fixtures/rails2.png" to "Attachment"
    And I press "Save"
    Then I should see "Attachment was successfully updated"
    And I should see "Attachment2"
    And the page should match "rails2.png"

    When I follow "Delete"
    Then I should see "Attachment was successfully destroyed"
    And I should not see "Attachment2"
