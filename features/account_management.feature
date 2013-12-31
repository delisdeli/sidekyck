Feature: Manage account
 
  As a human
  So that I make changes to my current account
  I want to be able to access account management features

@omniauth_test
Scenario: An existing user should be able to access their settings page
  Given I am signed in with provider "facebook"
  And I am on the homepage
  And I follow "Settings"
  Then I should be on the edit profile page for "fbuser"

@omniauth_test
Scenario: An existing user should be able to see their current providers
  Given I am signed in with provider "facebook"
  And I am on the edit profile page for "fbuser"
  Then I should see "facebook" between "Currenly authenticated through:" and "Add"

@omniauth_test
Scenario: An existing user can add another provider to their account
  Given I am signed in with provider "facebook"
  And I am on the edit profile page for "fbuser"
  And I follow "Login with Twitter"
  Then there should only be one user "fbuser"
  And user "twitteruser" should not exist

@omniauth_test
Scenario: An existing user won't be able to authenticate with the same provider twice
  Given I am signed in with provider "facebook"
  And I am on the edit profile page for "fbuser"
  Then I should not see "Login with Facebook"

@omniauth_test
Scenario: An existing user will not be able to delete forms of authentication if they have just one
  Given I am signed in with provider "facebook"
  And I am on the edit profile page for "fbuser"
  Then I should not see "Delete facebook"

@omniauth_test
Scenario: An existing user will be able to delete forms of authentication if they have more than one
  Given I am signed in with provider "facebook"
  And I am signed in with provider "twitter"
  And I am on the edit profile page for "fbuser"
  And I follow "Delete facebook"
  Then I should not see "facebook" between "Currenly authenticated through:" and "Add"
  And I should see "Login with Facebook"

@omniauth_test
Scenario: A non-admin cannot edit someone else's account
  Given I am signed in with provider "facebook"
  And I am on the signout page
  And I am signed in with provider "twitter"
  And I am on the edit profile page for "fbuser"
  Then I should be on the homepage

@omniauth_test
@javascript
Scenario: A user can delete their own account
  Given I am signed in with provider "facebook"
  And I am on the edit profile page for "fbuser"
  And I follow "Delete Account"
  And I accept the alert
  Then I should be on the home page
  And user "fbuser" should not exist
