@omniauth_test
Feature: Listing management
 
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
      | user_id  | title           | description  | status    | positions  | category  | audience  | price  |
      | 1        | first listing   | description  | active    | 1          | customer  | everyone  | 0      |
      | 1        | second listing  | description  | inactive  | 2          | customer  | everyone  | 0      |
      | 1        | third listing   | description  | inactive  | 0          | customer  | everyone  | 0      |

Scenario: Only active listings will be seen on the homepage
  Given I am on the homepage
  Then I should see "first listing"
  And I should not see "second listing"

Scenario: An unauthenticated user cannot create a listing
  Given I am on the homepage
  Then I should not see "Create Listing"

Scenario: an authenticated user cannot create a listing with invalid input
  Given I am signed in with provider "facebook"
  And I am on create listing page
  And I press "Save Listing"
  And I should see "6 errors prohibited this listing from being saved:"
  And I should see "Title can't be blank"
  And I should see "Description can't be blank"
  And I should see "Price can't be blank"
  And I should see "Price is not a number"
  And I should see "Positions can't be blank"
  And I should see "Positions is not a number"

Scenario: an authenticated user can create a listing with valid input
  Given I am signed in with provider "facebook"
  And I am on the homepage
  And I create a listing with "standard" input
  Then I should be on the show page for listing "standard listing"
  And I should see "standard listing" before "standard listing description"
  And I should see "standard listing"

Scenario: an authenticated user can edit one of his listings
  Given I am signed in with provider "facebook"
  And I am on the homepage
  And I follow "first listing"
  Then I should be on the show page for listing "first listing"
  And I should see "1 Open" after "Positions filled"
  When I follow "Edit"
  Then I should be on the edit page for listing "first listing"
  When I fill in "3" for "listing[positions]"
  And I press "Save Listing"
  Then I should be on the show page for listing "first listing"
  And I should see "3 Open" after "Positions filled"

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

@javascript
Scenario: Increasing the number of positions can reactivate a listing
  Given I am signed in with provider "facebook"
  And I am on the edit page for listing "third listing"
  Then I should not see "Listing will be reactivated with this change"
  And I fill in "listing[positions]" with "1"
  And I fill in "listing[title]" with "third listing" 
  Then I should see "Listing will be reactivated with this change"
  When I press "Save Listing"
  Then listing "third listing" should have status "active"

Scenario: The listing owner should be able to deactivate their listing
  Given I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  Then listing "first listing" should have status "active"
  Then I should not see "Activate Listing"
  And I follow "Deactivate Listing"
  Then listing "first listing" should have status "inactive"
  And I should not see "Deactivate Listing"
  And I should see "Add positions to activate listing"
  