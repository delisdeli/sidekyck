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
  Then I should be on the show page for listing "first listing"
  Then I should see "twitteruser" after "Applicants"
  And I should see "You have applied for this listing!"
  And I should not see "Apply"

Scenario: Applicants will be able to rescind their application
  Given I am signed in with provider "twitter"
  And I am on the homepage
  And I follow "first listing"
  And I follow "Apply"
  And I follow "Rescind Application"
  Then I should be on the show page for listing "first listing"
  Then I should see "You have rescinded your application."
  Then "twitteruser" should not be an applicant for listing "first listing"
  And I should not see "twitteruser" after "Applicants:"

@javascript
Scenario: The lister can select who to hire among applicants for a particular listing
  Given "twitteruser" has applied for "first listing"
  Given I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  And I follow "Hire"
  And I accept the alert
  Then I should be on the show page for listing "first listing"
  And I should see "twitteruser has been hired for this listing!"
  And listing "first listing" should have status "inactive"
  And I should see "twitteruser" after "Positions filled"
  And I should not see "twitteruser" between "Applicants:" and "Positions filled"  

@javascript
Scenario: A listing's status will be changed from active to inactive once positions are filled
  Given "twitteruser" is hired for "first listing"
  Then listing "first listing" should have status "inactive"

@javascript
Scenario: A listing's status will not be changed from active to inactive until positions are filled
  Given "twitteruser" is hired for "second listing"
  Then listing "first listing" should have status "active"  

@javascript
Scenario: When a user is hired, they will be able to indicate when they complete the job
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitter"
  And I am on the show page for listing "first listing"
  And I follow "Job Complete"
  And I accept the alert
  Then I should be on the show page for listing "first listing"
  And I should see "Job complete! Waiting for customer approval."
  And I should not see "Job Complete"
  And I should see "Quit Job"
  And I should see "Approval Pending"

@javascript
Scenario: When a user is hired, they will be able to quit jobs they haven't completed
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitter"
  And I am on the show page for listing "first listing"
  And I follow "Quit Job"
  And I accept the alert
  Then I should be on the show page for listing "first listing"
  And I should see "You have quit. Someone else will be able to fill your position."
  And listing "first listing" should have status "active"
  And I should not see "twitteruser Job quit on" after "Positions filled"

@javascript
Scenario: When a user is hired, they will be able to quit jobs they have completed
  Given "twitteruser" is hired for "first listing"
  And I am signed in with provider "twitter"
  And I am on the show page for listing "first listing"
  And I follow "Job Complete"
  And I accept the alert
  Then I should see "Approval Pending"
  And I follow "Quit Job"
  And I accept the alert
  Then I should be on the show page for listing "first listing"
  And I should see "You have quit. Someone else will be able to fill your position."
  And listing "first listing" should have status "active"
  And I should not see "twitteruser Job quit on" after "Positions filled"

@javascript
Scenario: Listers will be able to approve jobs that are marked as completed
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  And I follow "Approve"
  And I accept the alert
  Then I should be on the show page for listing "first listing"
  And I should see "Job approved!"
  And listing "first listing" should have status "inactive"
  And I should see "Job completed on" after "twitteruser"

@javascript
Scenario: Listers will be able to reactivate rejected jobs to the original hiree
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  And I follow "Reject"
  And I fill in "service[notes]" with "submit again"
  And I press "Rehire"
  Then I should see "Job not approved. twitteruser will be notified."
  Then "twitteruser" should be hired for "first listing"
  And listing "first listing" should have status "inactive"

@javascript
Scenario: Listers will be able to reactivate rejected jobs to the original audience
  Given "twitteruser" is hired for "first listing"
  And "twitteruser" completes listing "first listing"
  And I am signed in with provider "facebook"
  And I am on the show page for listing "first listing"
  And I follow "Reject"
  And I fill in "service[notes]" with "you're fired"
  And I press "Relist"
  Then I should see "Job not approved. This job has been relisted."
  Then "twitteruser" should not be hired for "first listing"
  And listing "first listing" should have status "active"

Scenario: When a user is hired, they will not be able to apply to the same listing until their job is terminated
