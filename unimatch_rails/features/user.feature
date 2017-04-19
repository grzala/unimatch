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
        Then I should see the message "Account created"
        
    Scenario: Log in and log out
		Given I have entered the main page
        And I create and login as user "test" "testtest"
		Then I should see the logout link
		And I click logout
		Then I should not see the message "test"
  
  Scenario: Wrong register credentials
        Given I have entered the main page
        When I click register
        And I fill in "user_email" with "testUser@wrongemailconvention"
        And I fill in "user_password" with "pass"
        And I fill in "user_password_confirmation" with "testtest"
        And I fill in "user_name" with "testname"
        And I fill in "user_surname" with "testsurname"
        And submit register form
		Then I should see the message "Wrong email format"
		And I should see the message "Password is too short"
		And I should see the message "Passwords do not match"
		And I should see the message "Account not created"
		
	Scenario: Wrong login credentials
		Given I have entered the main page
        And I fill in "email" with "testUser@test"
        And I fill in "password" with "ttt"
        And I click login
		Then I should see the message "Password and email do not match"