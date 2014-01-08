@omniauth_test
Feature: Service management
 
  As a user
  So that I can offer and perform services
  I want to be able to manage services

  Background:
    Given I am signed in with provider "facebook"
    And I am on the signout page
    And I am signed in with provider "twitter"
    And "twitteruser" is an admin user
    And I am on the signout page

    Given the following listings exist:
      | user_id  | title           | description  | start_time  | end_time  | status  | positions  | category  | audience  |
      | 1        | first listing   | description  | TODAY       | NEVER     | active  | 1          | customer  | everyone  |
      | 1        | second listing  | description  | TODAY       | NEVER     | active  | 2          | customer  | everyone  |

Scenario: Eligible users can apply for a listing
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "first listing"
  And I follow "Apply"
  Then "twitteruser" should be an applicant for listing "first listing"
  And I should see "You have applied for this listing!"

Scenario: Applicants will be able to rescind their application
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "first listing"
  And I follow "Apply"
  And I follow "Rescind Application"
  Then "twitteruser" should not be an applicant for listing "first listing"

Scenario: The lister can select who to hire among applicants for a particular listing
  Given "twitteruser" has applied for "first listing"
  Given I am signed in with provider "facebook"
  And I am on the show page for "first listing"
  And I follow "Hire"
  And I accept the alert
  Then I should be on the show page for "first listing"
  And I should see "twitteruser has been hired for this listing!"

Scenario: A listing's status will be changed from active to pending once positions are filled
  Given "twitteruser" is hired for "first listing"
  Then listing "first listing" should have status "pending"

Scenario: A listing's status will not be changed from active to pending until positions are filled
  Given "twitteruser" is hired for "second listing"
  Then listing "first listing" should be "active"  

Scenario: When a user is hired, they will be able to indicate when they complete the job
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitteruser"
  And I am on the show page for "first listing"
  And I follow "Job Complete"
  And I accept the alert
  Then I should be on the show page for "first listing"
  And I should see "Job complete! Waiting for customer approval."

Scenario: When a user is hired, they will be able to quit jobs
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitteruser"
  And I am on the show page for "first listing"
  And I follow "Quit Job"
  And I accept the alert
  Then I should be on the show page for "first listing"
  And I should see "You have quit. Someone else will be able to fill your position."

Scenario: Listers will be able to approve jobs that are marked as completed
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for "first listing"
  And I follow "Approve"
  And I accept the alert
  Then I should be on the show page for "first listing"
  And I should see "Job approved!"

Scenario: Listers will be able to reactivate rejected jobs to the original hiree
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for "first listing"
  And I follow "Reject"
  And I fill in "notes" with "submit again"
  And I follow "Rehire"
  And I accept the alert
  Then "twitteruser" should be hired for "first listing"
  And listing "first listing" should have status "pending"

Scenario: Listers will be able to reactivate rejected jobs to the original audience
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for "first listing"
  And I follow "Reject"
  And I fill in "notes" with "you're fired"
  And I follow "Relist"
  And I accept the alert
  Then "twitteruser" should not be hired for "first listing"
  And the listing "first listing" should have status "active"

Scenario: Listers will be able to approve a job well done!
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for "first listing"
  And I follow "Accept"
  And I accept the alert
  Then I should be on the show page for "first listing"
  And I should see "Job approved!"
  And the listing "first listing" should have status "inactive"
