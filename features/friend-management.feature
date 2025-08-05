Feature: Friend Management
  As a user of the messenger application
  I want to manage my friends list
  So that I can connect and communicate with people I know

  Background:
    Given the messenger application is running
    And I am logged in as user "john@example.com"
    And there is another user "jane@example.com" in the system

  Scenario: Add friend by email search
    When I search for friends using email "jane@example.com"
    Then I should see "jane@example.com" in search results
    When I send a friend request to "jane@example.com"
    Then a friend request should be sent
    And "jane@example.com" should receive a friend invitation notification

  Scenario: Add friend by phone number search
    Given user "jane@example.com" has phone number "+0987654321"
    When I search for friends using phone number "+0987654321"
    Then I should see the user with phone "+0987654321" in search results
    When I send a friend request to that user
    Then a friend request should be sent

  Scenario: Add friend by username search
    Given user "jane@example.com" has username "jane_doe"
    When I search for friends using username "jane_doe"
    Then I should see "jane_doe" in search results
    When I send a friend request to "jane_doe"
    Then a friend request should be sent

  Scenario: Add friend by QR code scan
    Given user "jane@example.com" generates a QR code
    When I scan the QR code
    Then I should see friend request option for "jane@example.com"
    When I confirm the friend request
    Then a friend request should be sent

  Scenario: Accept friend request
    Given I have a pending friend request from "jane@example.com"
    When I accept the friend request from "jane@example.com"
    Then "jane@example.com" should be added to my friends list
    And I should be added to "jane@example.com" friends list
    And both users should receive confirmation notifications

  Scenario: Reject friend request
    Given I have a pending friend request from "jane@example.com"
    When I reject the friend request from "jane@example.com"
    Then the friend request should be removed
    And "jane@example.com" should be notified of rejection

  Scenario: View friends list
    Given I have friends:
      | username | email              | status |
      | jane_doe | jane@example.com   | online |
      | bob_smith| bob@example.com    | offline|
    When I view my friends list
    Then I should see 2 friends
    And I should see "jane_doe" with online status
    And I should see "bob_smith" with offline status
    And I should see their profile pictures
    And I should see their last online time

  Scenario: Search friends in friends list
    Given I have 10 friends in my friends list
    When I search for "jane" in my friends list
    Then I should see only friends matching "jane"

  Scenario: Friend request expiration
    Given I sent a friend request to "jane@example.com" 31 days ago
    When the system runs daily cleanup
    Then the friend request should be automatically expired
    And "jane@example.com" should no longer see the request

  Scenario: Withdraw sent friend request
    Given I sent a friend request to "jane@example.com"
    And the request is still pending
    When I withdraw the friend request
    Then the request should be cancelled
    And "jane@example.com" should no longer see the request

  Scenario: Friend limit enforcement
    Given I have 500 friends (the maximum limit)
    When I try to add another friend
    Then the request should be rejected
    And I should see error "Friend limit reached (500 friends maximum)"

  Scenario: Organize friends into groups
    Given I have friends "jane@example.com" and "bob@example.com"
    When I create a friend group called "Work Colleagues"
    And I add "jane@example.com" and "bob@example.com" to "Work Colleagues"
    Then I should see "Work Colleagues" group with 2 members
    And I should be able to filter friends by group