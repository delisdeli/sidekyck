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
      | user_id  | title           | description  | start_time  | end_time  | status  | positions  | category  | audience  |
      | 1        | first listing   | description  | TODAY       | NEVER     | active  | 1          | customer  | everyone  |
      | 1        | second listing  | description  | TODAY       | NEVER     | active  | 2          | customer  | everyone  |

Scenario: When someone applies for my listing I should receive a notification
  Given "twitteruser" has applied for "first listing"
  And I am signed in with provider "facebook"
  And I follow "Bell icon"
  And I follow "twitteruser has applied for you listing!"
  Then I should be on the show page for listing "first listing"
  And I should see "twitteruser" after "Applicants"

Scenario: When a user is hired, they will receive a notification
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  And I follow "You've been hired for a listing!"
  Then I should be on the show page for the newest listing

Scenario: When a user quits one of my jobs, I will receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" quits listing "first listing"
  When I am signed in with provider "facebook"
  And I follow "Bell icon"
  Then I should see "twitteruser has quit."

Scenario: When the lister approves one of my jobs, I will be receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "facebookuser" approves listing "first listing"
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  When I follow "Your job has been approved!"
  I should see be on the show page for the newest listing

Scenario: When the lister rejects one of my jobs, I will receive a notification
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "facebookuser" rejects listing "first listing"
  Am I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Bell icon"
  And I follow "Your job has been rejected."
  Then I should be on the show page for newest listing
  