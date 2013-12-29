Feature: Friendship management
 
  As a user
  So that I can create relationships with other users
  I want to be manage friendships

  Background:
    Given the following users exist:
    | name   | email            | password  | password_confirmation  | admin  |
    | user1  | user1@email.com  | password  | password               | false  |
    | user2  | user2@email.com  | password  | password               | false  |
    | user3  | user3@email.com  | password  | password               | false  |
    | user4  | user4@email.com  | password  | password               | false  |

    Given the following friendships exist:
    | user_id  | friend_id  | status    |
    | 1        | 3          | accepted  |
    | 3        | 1          | accepted  |
    | 3        | 4          | pending   |
    | 4        | 3          | requested |

Scenario: A user will know they are friends with someone
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  Then I should not see "Already Friends"
  Given I am on the profile page for "user2"
  Then I should not see "Already Friends"
  Given I am on the profile page for "user3"
  Then I should see "Already Friends"

Scenario: A user cannot add themself as a friend
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  Then I should not see "Add Friend"

Scenario: A user can send a friend request to another user and they will have a pending/requested friendship
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user2"
  And I follow "Add Friend"
  Then I should be on the profile page for "user2"
  And I should see "Friend Request Sent" between "user2" and "Friends"
  And I should not see "Add Friend"
  Given I am on the profile page for "user1"
  Then I should see "user2" after "Friends Pending"
  Given I follow "Sign out"
  And I am logged in as "user2" with password "password"
  And I am on the profile page for "user2"
  Then I should see "user1" between "Friend Requests" and "Friends Pending"

Scenario: A user can delete a friendship request they sent
  Given I am logged in as "user3" with password "password"
  And I am on the profile page for "user3"
  Then I should see "user4" between "Friends Pending" and "Cancel Request"
  When I follow "Cancel Request"
  Then I should see "Friend request canceled."
  Then I should not see "user4" after "Friends Pending"
  Given I am on the profile page for "user4"
  Then I should not see "user3" after "Friends"
  Given I follow "Add Friend"
  And I follow "Cancel Request"
  Then I should see "Friend request canceled."
  Given I follow "Sign out"
  And I am logged in as "user4" with password "password"
  And I am on the profile page for "user4"
  Then I should not see "user3" after "Friends"

Scenario: A user cannot delete another users friendship request
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user3"
  Then I should not see "Cancel Request"

Scenario: After a user accepts a request, they will both have complementary 'accepted' friendships
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user2"
  And I follow "Add Friend"
  Then I should be on the profile page for "user2"
  And I should see "Friend Request Sent" between "user2" and "Friends"
  And I should not see "Add Friend"
  Given I follow "Sign out"
  And I am logged in as "user2" with password "password"
  And I am on the profile page for "user2"
  Then I should see "user1" between "Friend Requests" and "Friends Pending"
  When I follow "Accept Friendship"
  Then I should see "You are now friends!"
  Then I should be on the profile page for "user2"
  And I should not see "Accept Friendship"
  And I should see "user1" between "Friends" and "Friend Requests"
  Given I am on the profile page for "user1"
  Then I should see "user2" after "Friends"

Scenario: After a user rejects a request, they will both not have a friendship
  Given I am logged in as "user4" with password "password"
  And I am on the profile page for "user4"
  And I follow "Decline Friendship"
  Then I should see "You have declined a friendship."
  Then I should be on the profile page for "user4"
  And I should not see "user3"

Scenario: A user cannot delete a friendship that doesn't exist
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  Then I should not see "Delete Friendship" after "user2"
  Given I am on the profile page for "user2"
  Then I should not see "Delete Friendship"
  #And I try to delete my friendship with "user2"
  #Then I should be on the homepage
  #And I should see "Cannot delete a friendship that doesn't exist."
  
Scenario: After a user deletes a friendship, they will both no longer have a friendship
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  And I follow "End Friendship"
  Then I should be on the profile page for "user1"
  Then I should see "You have ended a friendship."
  And I should not see "user2"
  Given I am on the profile page for "user2"
  Then I should not see "user1" after "Friends"

@javascript
Scenario: When a user deletes his account, all his friendships should be deleted
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user1"
  And I follow "Edit Information"
  And I press "Cancel My Account"
  And I accept the alert
  And I am on the profile page for "user3"
  Then I should not see "user1" after "Friends"
  And no friendship should have friend or user id "1"
  