Feature: Account Authentication
 
  As a user
  So that I protect and access my information
  I want to be require user authentication

  #Background:
  #  Given the following users exist:
  #  | name       | email            | password  | password_confirmation  | admin |
  #  | user1      | user1@email.com  | password  | password               | false |

@omniauth_test
Scenario: a user can authenticate with facebook
  Given I am signed in with provider "facebook"
  And I am on the profile page for "facebookuser"
  Then I should see "facebookuser"

Scenario: an existing user can log in
  Given I am on the signin page
  And I fill in "user[email]" with "user1@email.com"
  And I fill in "user[password]" with "password"
  When I press "Sign in"
  Then I should see "Signed in successfully."
  And I should see "user1"

Scenario: an existing user will not be logged in given the wrong password
  Given I am on the signin page
  And I fill in "user[email]" with "user1@email.com"
  And I fill in "user[password]" with "wrongpassword"
  When I press "Sign in"
  Then I should see "Invalid"
  And I should not see "user1"

Scenario: Signed in user should see the correct user bar
  Given I am logged in as "user1" with password "password"
  And I am on the home page
  And I should not see "Register"
  When I follow "user1"
  Then I should be on the profile page for "user1"
  When I follow "Sign out"
  Then I should be on the home page
  And I should see "Sign in"

Scenario: Non-signed in user should see the correct user bar
  Given I am on the home page
  Then I should not see "Sign out"
  When I follow "Sign in"
  Then I should be on the signin page
  Given I am on the home page
  When I follow "Register"
  Then I should be on the signup page

