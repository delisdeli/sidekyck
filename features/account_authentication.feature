Feature: Account Creating and Authentication
 
  As a user
  So that I have a personalized experience
  I want to be able to create and authenticate my account through other providers

@omniauth_test
Scenario: a new user can create their account through facebook
  Given I am on the homepage
  And I follow "Login with Facebook"
  And I am on the profile page for "fbuser"
  Then I should see "fbuser"

@omniauth_test
Scenario: a new user can create their account through twitter
  Given I am on the homepage
  And I follow "Login with Twitter"
  And I am on the profile page for "twitteruser"
  Then I should see "twitteruser"

@omniauth_test
Scenario: an existing user can authenticate through a provider
  Given I am signed in with provider "twitter"
  And I am on the signout page
  And I am on the homepage
  And I follow "Login with Twitter"
  Then I should see "twitteruser"
  And there should only be one user "twitteruser"

@omniauth_test
Scenario: A signed in user should see the correct user bar
  Given I am signed in with provider "facebook"
  And I am on the home page
  And I should not see "Login with Facebook"
  And I should not see "Login with Twitter"
  And I should see "fbuser"
  And I should see "Settings"

@omniauth_test
Scenario: Non-signed in user should see the correct user bar
  Given I am on the home page
  Then I should not see "Sign out"
  And I should see "Login with Facebook"
  And I should see "Login with Twitter"
