Feature: create and manage accounts
 
  As a human
  So that I create and personalize a Boost create
  I want to be able to create and manage my account

  Background:
    Given the following users exist:
    | name       | email            | password  | password_confirmation  | admin |
    | user1      | user1@email.com  | password  | password               | false |
    | user2      | user2@email.com  | password  | password               | false |
    | admin      | admin@email.com  | password  | password               | true  |

Scenario: a user can be created
  Given I am on the signup page
  And I fill in "user[name]" with "somename"
  And I fill in "user[email]" with "someemail@email.com"
  And I fill in "user[password]" with "password"
  And I fill in "user[password_confirmation]" with "password"
  When I press "Save"
  Then I should be on the profile page for "somename"
  And I should see "somename"
  And I should not see "password"

Scenario: a user will not be created if the email is already taken
  Given I am on the signup page
  And I fill in "user[name]" with "somename"
  And I fill in "user[email]" with "user1@email.com"
  And I fill in "user[password]" with "password"
  And I fill in "user[password_confirmation]" with "password"
  When I press "Save"
  And I should see "taken"
  And I should see "Sign in"

Scenario: a user will not be created if password doesn't match password_confirmation
  Given I am on the signup page
  And I fill in "user[name]" with "somename"
  And I fill in "user[email]" with "someemail@email.com"
  And I fill in "user[password]" with "password"
  And I fill in "user[password_confirmation]" with "wrongpassword"
  When I press "Save"
  Then I should see "doesn't match"

Scenario: a user will not be created if email is not in the correct form
  Given I am on the signup page
  And I fill in "user[email]" with "email@berkeleycom"
  When I press "Save"
  Then I should see "Email is invalid"
  And I fill in "user[email]" with "email@berkeleycom"
  When I press "Save"
  Then I should see "Email is invalid"
  And I fill in "user[email]" with "emailberkeleycom"
  When I press "Save"
  Then I should see "Email is invalid"

Scenario: an existing user can edit his information by confirming his password
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  And I follow "Edit Information"
  And I fill in "user[name]" with "changedusername"
  And I fill in "user[email]" with "changedemail@email.com"
  And I fill in "user[password]" with "newpassword"
  And I fill in "user[password_confirmation]" with "newpassword"
  And I fill in "user[password_authenticate]" with "password"
  And I press "Save"
  Then I should see "Information was successfully updated."
  And I should see "changedusername"
  And I should see "changedemail@email.com"

Scenario: a user cannot change their information unless their password is confirmed
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  And I follow "Edit Information"
  And I fill in "user[name]" with "changedusername"
  And I fill in "user[email]" with "changedemail@email.com"
  And I fill in "user[password]" with "newpassword"
  And I fill in "user[password_confirmation]" with "newpassword"
  And I fill in "user[password_authenticate]" with "wrongpassword"
  And I press "Save"
  Then I should see "Wrong password."
  And I should not see "changedusername"
  And I should see "user1"

Scenario: A non-admin user cannot edit other users
  Given I am logged in as "user2" with password "password"
  And I am on the profile page for "user1"
  Then I should not see "Edit Information"
  Given I am on the edit page for user "user1"
  Then I should be on the home page
  And I should see "You are not authorized to access this function."

Scenario: A non-admin cannot delete someone else's account
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user2"
  Then I should not see "Delete Account"

@javascript
Scenario: A user can delete their own account
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  When I follow "Delete Account"
  And I accept the alert
  Then I should be on the home page
  And "user1" should not exist

@javascript
Scenario: An admin can delete a user record
  Given I am logged in as "admin" with password "password"
  And I am on the profile page for "user2"
  When I follow "Delete Account"
  And I accept the alert
  Then I should be on the home page
  And "user2" should not exist

#Scenario: Non-existent user show should give nice error
#  Given I am on the profile page for id "20"
#  Then I should see "That user doesn't exist"

#Scenario: Admin user can edit other users without typing their password
#  Given I am logged in as "admin" with password "password"
#  And I am on the edit page for user "user1"
#  Then I should see "Editing user"