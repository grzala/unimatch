Feature: Messaging
  
    @javascript
    Scenario: Slect User and write message
        Given I create and login as user "test" "testtest"
        And I user with id "2" exists
        And I visit user "2"
        And I click "message me"
        When I fill "message" with "hi"
        And I click "send"
        Then I should be able to see "hi" in "messages"