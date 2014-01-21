@omniauth_test
Feature: Listing managemen
 
  As a user
  So that I can advertise my offered and desired services
  I want to manage my listings

  Background:
    Given I am signed in with provider "facebook"
    And I am on the signout page
    And I am signed in with provider "twitter"
    And "twitteruser" is an admin user
    And I am on the signout page

    Given the following listings exist:
      | user_id  | title           | description  | start_time  | end_time  | status    | positions  | category  | audience  |
      | 1        | first listing   | description  | TODAY       | NEVER     | active    | 1          | customer  | everyone  |
      | 1        | second listing  | description  | TODAY       | NEVER     | inactive  | 2          | customer  | everyone  |

Scenario: Only active listings will be seen on the homepage
  Given I am on the homepage
  Then I should see "first listing"
  And I should not see "second listing"

Scenario: An unauthenticated user cannot create a listing
  Given I am on the homepage
  Then I should not see "Create Listing"

Scenario: an authenticated user can create a listing
  Given I am signed in with provider "facebook"
  And I am on the homepage
  And I create a listing with "standard" input
  Then I should be on the show page for listing "standard listing"
  And I should see "standard listing" before "standard listing description"
  And I should see "standard listing "

Scenario: an authenticated user can edit one of his listings
  Given I am signed in with provider "facebook"
  And I am on the homepage
  And I follow "first listing"
  Then I should be on the show page for listing "first listing"
  And I should see "0 of 1" after "Positions filled"
  When I follow "Edit"
  Then I should be on the edit page for listing "first listing"
  When I fill in "3" for "listing[positions]"
  And I press "Save Listing"
  Then I should be on the show page for listing "first listing"
  And I should see "0 of 3" after "Positions filled"

Scenario: An authenticated user can see all their live listings
  Given I am signed in with provider "facebook"
  And I am on the profile page for "fbuser"
  Then I should see "first listing" after "Listings"

Scenario: A user's friends can find their listings through their profile page
  Given "fbuser" and "twitteruser" are friends
  Given I am signed in with provider "twitter"
  And I am on the profile page for "fbuser"
  Then I should see "first listing" after "Listings"

Scenario: An everyone listing can be seen by everyone
  Given I am on the homepage
  Then I should see "first listing"
  Given I am signed in with provider "twitter"
  Then I should see "first listing"

Scenario: A friend only listing can ONLY be seen by accepted friends of the lister
  Given "fbuser" and "twitteruser" are friends
  And I am signed in with provider "facebook"
  And I am on the homepage
  And I create a listing with "friend-only" input
  Then I should be on the show page for listing "friend-only listing"
  Given I am on the signout page
  And I am on the homepage
  Then I should not see "friend-only listing"
  Given I am signed in with provider "twitter"
  And I am on the homepage
  Then I should see "friend-only listing"

@javascript
Scenario: Listers can delete their listings
  Given I am signed in with provider "facebook"
  And I am on the homepage
  And I create a listing with "standard" input
  Then I should be on the show page for listing "standard listing"
  And I follow "Delete Listing"
  And I accept the alert
  Then I should be on the homepage
  And listing "standard listing" should not exist
