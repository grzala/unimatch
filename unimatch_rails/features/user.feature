Feature: register and login
  
    Scenario: Register and log in
        Given I have entered the main page
        When I click register
        And I fill in "user_email" with "testUser@abdn.ac.uk"
        And I fill in "user_password" with "testtest"
        And I fill in "user_password_confirmation" with "testtest"
        And I fill in "user_name" with "testname"
        And I fill in "user_surname" with "testsurname"
        And submit register form
        And I log in as "testUser@abdn.ac.uk" "testtest"
        Then I should see the message "testname"
		And I should see the logout link
        
    Scenario: Log in and log out
		Given I have entered the main page
        Given I create and login as user "test" "testtest"
		Then I should see the logout link
		And I click logout
		Then I should not see the message "test"