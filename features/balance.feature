 @omniauth_test
Feature: Balance
 
  As a user
  So that I can provide and receive payments for the completion of services
  I want to be able to maintain a balance

  Background:
    Given I am signed in with provider "facebook"
    And I am on the signout page
    And I am signed in with provider "twitter"
    And I am on the signout page
    And "fbuser" has a balance of "10"

    Given the following listings exist:
      | user_id  | title           | description  | start_time  | end_time  | status  | positions  | category  | audience  | price  |
      | 1        | first listing   | description  | TODAY       | NEVER     | active  | 1          | customer  | everyone  | 10     |

Scenario: When a user creates a listing, they'll be stopped if the product of the listings price and num positions is greater than their available balance
  Given I am signed in with provider "facebook"
  And I create a listing with "balance" input
  Then I should see "Your balance must be at least $10 more to create this listing"
  And listing "balance listing" should not exist

Scenario: When a user creates a listing, the product of price and positions will be frozen from their balance
  Given "fbuser" has a balance of "20"
  Given I am signed in with provider "facebook"
  And I create a listing with "balance" input
  When I am on the profile page for "fbuser"
  Then I should see "Balance $20 Frozen Balance $20"

Scenario: When a user edits a listing, they'll be stopped if the new product of the listings price and num positions is greater than their available balance
  Given I am signed in with provider "facebook"
  And I am on the edit page for listing "first listing"
  And I fill in "listing[positions]" with "2"
  And I press "Save Listing"
  Then I should see "Your balance must be at least $10 more to create this listing"
  When I fill in "listing[positions]" with "2"
  And I fill in "listing[price]" with "5"
  And I press "Save Listing"
  Then I should be on the show page for listing "first listing"

@javascript
Scenario: When a user is hired, the service he's hired for will be set to the current listing price
  Given "twitteruser" is hired for "first listing"
  And I am on the show page for listing "first listing"
  Then I should see "$10 twitteruser"

@javascript
Scenario: When a user is hired, the lister will have that amount frozen no matter if the listing price changes
  Given "twitteruser" is hired for "first listing"
  And I am on the edit page for listing "first listing"
  And I fill in "listing[price]" with "5"
  And I am on the show page for listing "first listing"
  Then I should see "$10 twitteruser"
  And "twitteruser" should have a frozen balance of "10"

@javascript
Scenario: When a user is hired, that value will be considered when listing
  Given "fbuser" has a balance of "15"
  And "twitteruser" is hired for "first listing"
  And I am signed in with provider "facebook"
  When I am on the edit page for listing "first listing"
  And I fill in "listing[positions]" with "6"
  And I fill in "listing[price]" with "1"
  And I press "Save Listing"
  Then I should see "Your balance must be at least $1 more to create this listing"
  When I fill in "listing[positions]" with "5"
  And I fill in "listing[price]" with "1"
  And I press "Save Listing"
  Then I should be on the show page for listing "first listing"
  And I should see "$1 "
  Then I should see "$10 twitteruser"

@javascript
Scenario: When a user quits, the respective lister will have the hire prize unfrozen and the current listing price frozen
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "facebook"
  When I am on the edit page for listing "first listing"
  And I fill in "listing[price]" with "0"
  And I press "Save Listing"
  And "twitteruser" quits listing "first listing"
  Then "fbuser" should have a balance of "10"
  And "fbuser" should have a frozen balance of "0"

@javascript
Scenario: When a user is rehired, their service and the lister's frozen balance should remain unchanged
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "fbuser" rehires me for listing "first listing"
  Then "fbuser" should have a balance of "10"
  And "fbuser" should have a frozen balance of "10"

@javascript
Scenario: When a user is released, the respective lister will have the hire prize unfrozen and the current listing price frozen
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "facebook"
  When I am on the edit page for listing "first listing"
  And I fill in "listing[price]" with "5"
  And I press "Save Listing"
  And "twitteruser" completes listing "first listing"
  And "fbuser" relists listing "first listing"
  Then "fbuser" should have a balance of "10"
  And "fbuser" should have a frozen balance of "5"

@javascript
Scenario: When a user is approved, the hire_price will be transfered from the lister's to the provider's balance
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And "fbuser" approves listing "first listing"
  Then "fbuser" should have a balance of "0"
  Then "fbuser" should have a frozen balance of "0"
  Then "twitteruser" should have a balance of "10"

Scenario: When a user deactivates a listing, the credit value of the unfilled positions will be unfrozen
  And I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  And I follow "Deactivate Listing"
  Then "fbuser" should have a balance of "10"
  Then "fbuser" should have a frozen balance of "0"

@javascript
Scenario: When a user destroys a listing, the credit value of the unfilled positions will be unfrozen
  And I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  And I follow "Delete Listing"
  And I accept the alert
  Then "fbuser" should have a balance of "10"
  Then "fbuser" should have a frozen balance of "0"

@javascript
Scenario: When a user destroys his account, the balance will be transfered to the admin user
  Given "fbuser" is an admin user
  And "twitteruser" has a balance of "10"
  And I am signed in with provider "twitter"
  And I am on the edit profile page for "twitteruser"
  And I follow "Delete Account"
  And I accept the alert
  Then "fbuser" should have a balance of "20"
