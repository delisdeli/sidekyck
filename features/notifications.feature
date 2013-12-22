Feature: Notifications
 
  As a user
  So that I can be aware of changes with regards to my account
  I want to be able to receive notifications

  Background:
    Given the following users exist:
    | name  | email            | password  | password_confirmation  | admin  |
    | user  | user1@email.com  | password  | password               | false  |

    Given the following notifications exist:
    | user_id  | body                        | seen  |
    | 1        | "contents of notification"  | false |

    Given I am logged in as "user" with password "password"

Scenario: a user can see how many unread notifications they have on their user bar
  Given I am on the homepage
  Then I should see "1"
  When I create "45" new notifications for "user"
  And I am on the homepage
  Then I should see "46"

Scenario: notification counter will dissapear when notifications are read
  Given I am on the homepage
  Then I should see "1"
  When I follow "notifications"
  Then I should not see "1"
  When I follow "notifications"
  Then I should not see "1"

Scenario: a user can see all their past notifications
  Given I am on the homepage
  When I follow "notifications"
  And I go to the profile page for "user"
  Then I should see "contents of notification"

Scenario: a user will only have their most recent 50 notifications saved
  Given I create "50" new notifications for "user"
  When I go to the profile page for "user"
  Then I should not see "contents of notification"
  And I should see "just another notification"