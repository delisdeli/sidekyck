@omniauth_test
Feature: Friendship management
 
  As a user
  So that I can create relationships with other users
  I want to be manage friendships

  Background:
    Given I am signed in with provider "facebook"
    And I am on the signout page
    And I am signed in with provider "twitter"
    And I am on the signout page

Scenario: A user will know they are not friends with someone
  Given I am signed in with provider "twitter"
  And I am on the profile page for "fbuser"
  Then I should not see "Already Friends"
  Given the following friendships exist:
    | user_id  | friend_id  | status     |
    | 1        | 2          | requested  |
    | 2        | 1          | pending    |
  And I am on the profile page for "fbuser"
  Then I should not see "Already Friends"
  Given I am on the signout page
  And I am signed in with provider "facebook"
  And I am on the profile page for "twitteruser"
  Then I should not see "Already Friends"

Scenario: A user will know they are friends with someone
  Given the following friendships exist:
    | user_id  | friend_id  | status    |
    | 1        | 2          | accepted  |
    | 2        | 1          | accepted  |
  Given I am signed in with provider "facebook"
  And I am on the profile page for "twitteruser"
  Then I should see "Already Friends"
  Given I am signed in with provider "twitter"
  And I am on the profile page for "fbuser"
  Then I should see "Already Friends"

Scenario: A user cannot add themself as a friend
  Given I am signed in with provider "facebook"
  And I am on the profile page for "fbuser"
  Then I should not see "Add Friend"

Scenario: A user can send a friend request to another user and they will have a pending/requested friendship
  Given I am signed in with provider "facebook"
  And I am on the profile page for "twitteruser"
  And I follow "Add Friend"
  Then I should be on the profile page for "twitteruser"
  And I should see "Friend Request Sent" between "twitteruser" and "Friends"
  And I should not see "Add Friend"
  Given I am on the profile page for "fbuser"
  Then I should see "twitteruser" after "Friends Pending"
  Given I am on the signout page
  And I am signed in with provider "twitter"
  And I am on the profile page for "twitteruser"
  Then I should see "fbuser" between "Friend Requests" and "Friends Pending"

Scenario: A user can delete a friendship request they sent
  Given the following friendships exist:
    | user_id  | friend_id  | status     |
    | 1        | 2          | pending    |
    | 2        | 1          | requested  |
  Given I am signed in with provider "facebook"
  And I am on the profile page for "fbuser"
  Then I should see "twitteruser" between "Friends Pending" and "Cancel Request"
  When I follow "Cancel Request"
  Then I should see "Friend request canceled."
  Then I should not see "twitteruser" after "Friends Pending"
  Given I am on the profile page for "twitteruser"
  Then I should not see "fbuser" after "Friends"
  Given I follow "Add Friend"
  And I follow "Cancel Request"
  Then I should see "Friend request canceled."
  Given I am on the signout page
  And I am signed in with provider "twitter"
  And I am on the profile page for "twitteruser"
  Then I should not see "fbuser" after "Friends"

Scenario: A user cannot delete another users friendship request
  Given the following friendships exist:
    | user_id  | friend_id  | status     |
    | 1        | 2          | pending    |
    | 2        | 1          | requested  |
  Given I am signed in with provider "twitter"
  And I am on the profile page for "twitteruser"
  Then I should not see "Cancel Request"

Scenario: After a user accepts a request, they will both have complementary 'accepted' friendships
  Given I am signed in with provider "facebook"
  And I am on the profile page for "twitteruser"
  And I follow "Add Friend"
  Then I should be on the profile page for "twitteruser"
  And I should see "Friend Request Sent" between "twitteruser" and "Friends"
  And I should not see "Add Friend"
  Given I am on the signout page
  And I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Friend request"
  Then I should see "fbuser" before "View all friendship requests"
  And I should see "Decline"
  When I follow "Accept"
  Then I should see "You are now friends!"
  And I should be on the listings page
  Given I am on the profile page for "twitteruser"
  Then I should see "fbuser" after "Friends"
  Given I am on the profile page for "fbuser"
  Then I should see "twitteruser" after "Friends"

Scenario: After a user rejects a request, they will both not have a friendship
  Given the following friendships exist:
    | user_id  | friend_id  | status     |
    | 1        | 2          | pending    |
    | 2        | 1          | requested  |
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "Friend request"
  And I follow "Decline"
  Then I should see "You have declined a friendship."
  And I should be on the listings page
  Given I am on the profile page for "twitteruser"
  Then I should not see "fbuser"
  Given I am on the profile page for "fbuser"
  And I should not see "twitteruser" after "Friends"

Scenario: A user cannot delete a friendship that doesn't exist
  Given I am signed in with provider "facebook"
  And I am on the profile page for "fbuser"
  Then I should not see "Delete Friendship"
  
Scenario: After a user deletes a friendship, they will both no longer have a friendship
  Given the following friendships exist:
    | user_id  | friend_id  | status    |
    | 1        | 2          | accepted  |
    | 2        | 1          | accepted  |
  Given I am signed in with provider "facebook"
  And I am on the profile page for "twitteruser"
  And I follow "End Friendship"
  Then I should be on the profile page for "twitteruser"
  Then I should see "You have ended a friendship."
  And I should not see "fbuser" after "Friends"
  Given I am on the profile page for "fbuser"
  Then I should not see "twitteruser"

@javascript
Scenario: When a user deletes his account, all his friendships should be deleted
  Given I am signed in with provider "facebook"
  And I am on the edit profile page for "fbuser"
  And I follow "Delete Account"
  And I accept the alert
  And I am on the profile page for "twitteruser"
  Then I should not see "fbuser"
  And no friendship should have friend or user id "1"
