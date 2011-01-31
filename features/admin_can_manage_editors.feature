Feature: Manage editors
  In order to have editors
  As an admin
  I want to be able to manage editors

  Background:
    Given I am logged in as admin
    And I follow "Administration"

    @wip
  Scenario: Admin can create editors
    When I follow "Editors"
    And I follow "New editor"

