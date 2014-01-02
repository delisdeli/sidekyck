@omniauth_test
Feature: Friendship changes should send friendship notifications to users
 
  As a user
  So that I will know when changes occur with my friendships
  I want to receive friendship notifications from certain friendship changes

  Background:
    Given I am signed in with provider "facebook"
    And I am on the signout page
    And I am signed in with provider "twitter"
    And I am on the signout page

    Given the following friendships exist:
    | user_id  | friend_id  | status    |
    | 1        | 2          | pending   |
    | 2        | 1          | requested |

Scenario: A user should can see number of friend requests on their menu bar
  Given I am signed in with provider "twitter"
  And I am on the homepage
  Then I should see "1"
  When I follow "Friend request"
  And I follow "Friend request"
  Then I should see "1"
  When I follow "Friend request"
  And I follow "Accept"
  And I follow "Friend request"
  Then I should be on the listings page
  And I should not see "1"

Scenario: a user will receive a notification when a friend accepts their friendship
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Friend request"
  And I follow "Accept"
  And I am on the signout page
  And I am signed in with provider "facebook"
  And I am on the homepage
  When I follow "Bell icon"
  And I follow "You are now friends with twitteruser!"
  Then I should be on the profile page for "twitteruser"