@omniauth_test
Feature: Service notification
 
  As a user
  So that I am aware of the status of my offered & provided services
  I want to receive notifications for offered & provided service updates

  Background:
    Given I am signed in with provider "facebook"
    And I am on the signout page
    And I am signed in with provider "twitter"
    And "twitteruser" is an admin user
    And I am on the signout page

    Given the following listings exist:
      | user_id  | title           | description  | start_time  | end_time  | status  | positions  | category  | audience  | price  |
      | 1        | first listing   | description  | TODAY       | NEVER     | active  | 1          | customer  | everyone  | 0      |
      | 1        | second listing  | description  | TODAY       | NEVER     | active  | 2          | customer  | everyone  | 0      |

Scenario: When someone applies for my listing I should receive a notification
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "first listing"
  And I follow "Apply"
  And I am signed in with provider "facebook"
  And I follow "Bell icon"
  And I follow "twitteruser has applied for your listing!"
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"
  And I should see "twitteruser" after "Applicants"

@javascript
Scenario: When a user is hired, they will receive a notification
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  And I follow "You've been hired for a listing!"
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"

@javascript
Scenario: When a user quits one of my jobs, I will receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" quits listing "first listing"
  When I am signed in with provider "facebook"
  And I follow "Bell icon"
  And I follow "twitteruser quit."
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"

@javascript
Scenario: When a user completes one of my jobs, I will receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  When I am signed in with provider "facebook"
  And I follow "Bell icon"
  And I follow "twitteruser has completed a task for you, let them know how they did!"
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"

@javascript
Scenario: When the lister approves one of my jobs, I will be receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "fbuser" approves listing "first listing"
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  When I follow "Your job has been approved!"
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"

@javascript
Scenario: When the lister rejects one of my jobs and rehires me, I will receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "fbuser" rehires me for listing "first listing"
  And I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  And I follow "Your job has been rejected, see what still needs to be done."
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"

@javascript
Scenario: When the lister rejects one of my jobs and relists, I will receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "fbuser" relists listing "first listing"
  And I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  And I follow "Your job has been rejected and relisted."
  Then I should see "twitteruser"
  And I should be on the show page for listing "first listing"
