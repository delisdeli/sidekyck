@omniauth_test
Feature: Notifications
 
  As a user
  So that I can be aware of changes with regards to my account
  I want to be able to receive notifications

  Background:
    Given I am signed in with provider "facebook"

    Given the following notifications exist:
    | user_id  | body                        | seen  | tunnel  |
    | 1        | contents of notification    | false | /       |

Scenario: a user should not see their notifications until they check them
  Given I am on the homepage
  Then I should not see "contents of notification"

Scenario: a user can see how many unread notifications they have on their user bar
  Given I am on the homepage
  Then I should see "1"
  When I create "45" new notifications for "fbuser"
  And I am on the homepage
  Then I should see "46"

Scenario: notification counter will dissapear when notifications are read
  Given I am on the homepage
  Then I should see "1"
  When I follow "Bell icon"
  Then I should not see "1"
  When I follow "Bell icon"
  Then I should not see "1"

Scenario: a user can read all their unseen notifications through their user bar
  Given I am on the homepage
  And I follow "Bell icon"
  Then I should see "contents of notification" before "View all notifications"
  When I follow "Bell icon"
  And I follow "Bell icon"
  Then I should not see "conents of notification"

Scenario: a user can see all their past notifications
  Given I am on the homepage
  When I follow "Bell icon"
  And I follow "View all notifications"
  Then I should see "contents of notification"

Scenario: a user will only have their most recent 50 notifications saved
  Given I create "50" new notifications for "fbuser"
  When I go to the profile page for "fbuser"
  Then I should not see "contents of notification"
  And I should see "just another notification"

Scenario: a notification with a path will be clickable
  Given I am on the homepage
  And I follow "Bell icon"
  And I follow "contents of notification"
  Then I should be on the home page

@javascript
Scenario: When a user deletes his account, all his notifications should be deleted
  Given I am on the homepage
  And I follow "Settings icon"
  And I follow "Delete Account"
  And I accept the alert
  Then I should be on the homepage
  And no notification should have user id "1"
