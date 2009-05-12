Feature: Restrict access to posts admin panel for non-administrator
  In order posts admin panel to be accessible only for an administrator
  As a non-administrator
  I should not be able to open posts administration pages

  Scenario: Protect viewing posts for non administrators
    Given I am not an administrator
    When I go to list of blog posts in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect viewing post for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I go to blog post with id 1 in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect editing post for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I go to edit blog post with id 1 in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect requesting form for new post for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I go to new blog post in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect from posting a post for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I do create a post in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect from updating a post for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I do update a post with id 1 in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect from deleting a post for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I do delete a post with id 1 in administration
    Then I should see "HTTP Basic: Access denied."

  Scenario: Protect from accessing delete post page for non administrators
    Given Site has post with id 1
    And I am not an administrator
    When I go to delete blog post with id 1 in administration
    Then I should see "HTTP Basic: Access denied."
