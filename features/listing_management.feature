@omniauth_test
Feature: Listing management
 
  As a user
  So that I can advertise my offered and desired services
  I want to manage my listings

  Background:
    Given I am signed in with authentication "facebook"
    And I am on the signout page
    And I am signed in with authentication "twitter"
    And "twitteruser" is an admin user
    And I am on the signout page

    Given the following listings exist:
    | user_id  | body                        | seen  | tunnel  |
    | 1        | contents of notification    | false | /       |

Scenario: An unauthenticated user cannot create a listing
  Given I am on the homepage
  Then I should not see "Create Listing"

Scenario: an authenticated user can create a listing
  Given I am signed in with authentication "facebook"
  And I am on the homepage
  And I follow "Create Listing"

Scenario: A public listing can be seen by everyone

Scenario: A friend only listing can only be seen by accepted friends of the lister

Scenario: A friend only listing can not be seen by users not friends with the lister

@javascript
Scenario: Listers can delete their listings

Scenario: Eligible users can apply for a listing

Scenario: The lister can select who to hire among applicants for a particular listing

Scenario: When a user is hired, they will be able to indicate when they complete the job

Scenario: When a user is hired, they will be able to quit jobs

Scenario: Listers will be able to approve or reject jobs that are marked as completed

Scenario: Listers will be able to reactivate rejected jobs to the original hiree

Scenario: Listers will be able to reactivate rejected jobs to the original audience

Scenario: Listers will be able to approve a job well done!