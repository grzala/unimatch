Feature: register and login
  
    Scenario: Register and log in
        Given I have entered the main page
        When I click register
        And I fill in "user_email" with "testUser@abdn.ac.uk"
        And I fill in "user_password" with "testtest"
        And I fill in "user_name" with "testtest"
        And I fill in "user_surname" with "TEST TEST"
        And submit register form
        And I log in as "testUser@abdn.ac.uk" "testtest"
        Then I should see the message "You are logged in as testtest"