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

    Given the following listings exist:
      | user_id  | title           | description  | start_time  | end_time  | status  | positions  | category  | audience  | price  |
      | 1        | first listing   | description  | TODAY       | NEVER     | active  | 1          | customer  | everyone  | 10     |

Scenario: When a user creates a listing, they'll be stopped if the product of the listings price and num positions is greater than their available balance

Scenario: When a user creates a listing, the value of the price and positions product will be frozen from their balance

Scenario: When a user is hired, the service he's hired for will be set to the current listing price

Scenario: When a provider completes a service, the hire_price will be transfered from the lister's frozen balance to the provider

Scenario: When a user changes the number of positions, the frozen balance will reflect this
#make sure to check for different price for active services

Scenario: When a user destroys a listing, the credit value of the unfilled positions will be unfrozen

Scenario: When a user destroys a listing, all active services will be approved and paid out

Scenario: When a user destroys his account, the balance will be transfered to the admin user
  Given "facebookuser" is an admin user
