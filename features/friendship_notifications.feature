Feature: Friendship changes should send notifications to users
 
  As a user
  So that I will know when changes occur with my friendships
  I want to receive notifications from certain friendship changes

  Background:
    Given the following users exist:
    | name   | email            | password  | password_confirmation  | admin  |
    | user1  | user1@email.com  | password  | password               | false  |
    | user2  | user2@email.com  | password  | password               | false  |
    | user3  | user3@email.com  | password  | password               | false  |

    Given the following friendships exist:
    | user_id  | friend_id  | status    |
    | 1        | 3          | pending   |
    | 3        | 1          | requested |

Scenario: a user will receive a notification when they receive a friend request
  Given I am logged in as "user1" with password "password"
  And I am on the profile page for "user2"
  And I follow "Add Friend"
  Given I follow "Sign out"
  And I am logged in as "user2" with password "password"
  And I follow "notifications"
  And I follow "user1 has sent you a friend request."
  Then I should be on the profile page for "user1"
  And I should see "Accept Friendship"

Scenario: a user will receive a notification when a friend accepts their friendship
  Given I am logged in as "user3" with password "password"
  And I am on the profile page for "user1"
  And I follow "Accept Friendship"
  Given I follow "Sign out"
  And I am logged in as "user1" with password "password"
  And I am on the homepage
  When I follow "notifications"
  And I follow "You are now friends with user3!"
  Then I should be on the profile page for "user3"