Feature: Online Status and Privacy
  As a user of the messenger application
  I want to control my online status and privacy settings
  So that I can manage how others see and interact with me

  Background:
    Given the messenger application is running
    And I am logged in as user "john@example.com"
    And I have friends "jane@example.com", "bob@example.com", and "alice@example.com"

  Scenario: Set online status to online
    When I set my status to "online"
    Then my friends should see me as online with green indicator
    And my status should update in real-time
    And my last seen should show "online now"

  Scenario: Set online status to busy
    When I set my status to "busy"
    Then my friends should see me as busy with red indicator
    And I should still receive messages
    And others should know I might not respond immediately

  Scenario: Set online status to away
    When I set my status to "away"
    Then my friends should see me as away with yellow indicator
    And the status should automatically change back to online when I'm active
    And my away time should be tracked

  Scenario: Set online status to invisible
    Given I am currently online
    When I set my status to "invisible"
    Then my friends should see me as offline (gray indicator)
    But I should still be able to send and receive messages
    And I should see others' real status while appearing offline

  Scenario: Automatic status detection
    Given I am currently online
    When I don't interact with the app for 10 minutes
    Then my status should automatically change to "away"
    When I interact with the app again
    Then my status should return to "online"

  Scenario: Configure who can search for me - Everyone
    When I set my search privacy to "everyone"
    Then any user should be able to find me by email, phone, or username
    And I should appear in general user searches

  Scenario: Configure who can search for me - Friends only
    When I set my search privacy to "friends only"
    Then only my existing friends should be able to search for me
    And strangers should not find me in searches

  Scenario: Configure who can search for me - Nobody
    When I set my search privacy to "nobody"
    Then no one should be able to find me through search
    And I should be completely hidden from search results

  Scenario: Configure who can message me - Everyone
    When I set my messaging privacy to "everyone"
    Then any user should be able to send me messages
    And I should receive messages from strangers

  Scenario: Configure who can message me - Friends only
    When I set my messaging privacy to "friends only"
    Then only my friends should be able to message me
    And messages from non-friends should be blocked

  Scenario: Configure who can message me - Contacts only
    When I set my messaging privacy to "contacts only"
    Then only users in my phone contacts should be able to message me
    And all other messages should be filtered

  Scenario: Hide last seen time
    Given I was last active 2 hours ago
    When I set "hide last seen" to enabled
    Then my friends should not see my last seen time
    And my status should show as "online" or "offline" without timestamp

  Scenario: Show last seen time
    Given I was last active 2 hours ago
    When I set "hide last seen" to disabled
    Then my friends should see "last seen 2 hours ago"
    And the timestamp should update accurately

  Scenario: Hide read receipts
    Given "jane@example.com" sent me a message
    When I read the message with read receipts disabled
    Then "jane@example.com" should not see that I read the message
    And the message should remain showing as "delivered" for them

  Scenario: Show read receipts
    Given "jane@example.com" sent me a message
    When I read the message with read receipts enabled
    Then "jane@example.com" should see that I read the message
    And the message should show "read" status with timestamp

  Scenario: Block group invitations from everyone
    When I set group invitation privacy to "disabled"
    Then no one should be able to invite me to groups
    And all group invitations should be automatically declined

  Scenario: Allow group invitations from friends only
    When I set group invitation privacy to "friends only"
    Then only my friends should be able to invite me to groups
    And invitations from strangers should be blocked

  Scenario: Allow all group invitations
    When I set group invitation privacy to "everyone"
    Then anyone should be able to invite me to groups
    And I should receive all group invitations

  Scenario: Online status visibility based on privacy settings
    Given I have mutual friends with "bob@example.com"
    And my online status privacy is set to "friends only"
    When I go online
    Then "bob@example.com" should see my online status
    But strangers should not see my online status

  Scenario: Activity-based status updates
    Given I am in a voice call
    When my status is set to "online"
    Then my friends should see "online" status
    And the status should persist during the call

  Scenario: Cross-platform status synchronization
    Given I am logged in on mobile and desktop
    When I change my status to "busy" on mobile
    Then my desktop should also show "busy" status
    And all my friends should see the updated status from both devices

  Scenario: Status message customization
    When I set my status message to "In a meeting until 3 PM"
    Then my friends should see my custom status message
    And the message should be displayed alongside my online status

  Scenario: Privacy settings inheritance for new friends
    Given my default privacy settings are restrictive
    When I add a new friend "new_friend@example.com"
    Then the new friend should respect my existing privacy settings
    And they should only see what my settings allow

  Scenario: Temporary status override
    Given I am set to "invisible"
    When I send a message to "jane@example.com"
    Then "jane@example.com" should see I'm active (message sent recently)
    But my official status should remain "invisible" to others
    And my last seen should not be updated for others

  Scenario: Privacy audit log
    When I change my privacy settings multiple times
    Then I should be able to view a log of my privacy changes
    And I should see when each setting was modified
    And I should understand what each change affects