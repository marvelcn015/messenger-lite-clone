Feature: Notification System
  As a user of the messenger application
  I want to receive timely notifications
  So that I don't miss important messages and events

  Background:
    Given the messenger application is running
    And I am logged in as user "john@example.com"
    And I have notifications enabled

  Scenario: Receive new message notification
    Given "jane@example.com" is my friend
    When "jane@example.com" sends me a message "Hello John!"
    Then I should receive a push notification
    And the notification should show sender "jane@example.com"
    And the notification should show message preview "Hello John!"
    And the notification should have sound alert
    And the notification should have vibration (if on mobile)

  Scenario: Receive friend request notification
    Given "bob@example.com" is not my friend
    When "bob@example.com" sends me a friend request
    Then I should receive a notification about the friend request
    And the notification should show "Friend request from bob@example.com"
    And I should be able to accept/reject from the notification

  Scenario: Receive group invitation notification
    Given "alice@example.com" created a group "Project Team"
    When "alice@example.com" invites me to the group
    Then I should receive a group invitation notification
    And the notification should show group name "Project Team"
    And the notification should show inviter "alice@example.com"
    And I should be able to join/decline from the notification

  Scenario: Receive system announcement notification
    Given there is a system maintenance scheduled
    When the system sends an announcement about maintenance
    Then I should receive a system notification
    And the notification should be marked as important
    And the notification should be persistently visible

  Scenario: Turn off push notifications
    Given I have push notifications enabled
    When I disable push notifications in settings
    Then I should not receive any push notifications
    But in-app notifications should still work
    And notification badges should still update

  Scenario: Turn off sound alerts
    Given I have sound alerts enabled
    When I disable sound alerts in settings
    Then notifications should appear without sound
    But push notifications and vibrations should still work

  Scenario: Turn off vibration alerts
    Given I have vibration alerts enabled on mobile
    When I disable vibration alerts in settings
    Then notifications should appear without vibration
    But push notifications and sound should still work

  Scenario: Set do not disturb schedule
    Given it's currently 9:00 PM
    When I set do not disturb from 10:00 PM to 8:00 AM
    And "jane@example.com" sends me a message at 11:00 PM
    Then I should not receive notifications
    But the message should still be delivered
    And I should see the message when I check the app

  Scenario: Emergency notification override
    Given I have do not disturb enabled
    When I receive 3 consecutive messages from "jane@example.com" within 5 minutes
    Then the 3rd message should trigger an emergency notification
    And I should receive the notification despite do not disturb
    And the notification should be marked as emergency

  Scenario: Important contact notification exception
    Given I have do not disturb enabled
    And I marked "jane@example.com" as important contact
    When "jane@example.com" sends me a message
    Then I should receive the notification despite do not disturb
    And the notification should be marked as from important contact

  Scenario: Configure notification per contact
    Given "jane@example.com" is my friend
    When I set custom notification for "jane@example.com" to "sound only"
    And "jane@example.com" sends me a message
    Then I should receive sound notification only
    And there should be no push notification or vibration

  Scenario: Mute specific contact notifications
    Given "bob@example.com" is my friend
    When I mute notifications from "bob@example.com"
    And "bob@example.com" sends me messages
    Then I should not receive any notifications from "bob@example.com"
    But messages should still be delivered and marked as unread

  Scenario: Group mention notification
    Given I am in group "Team Discussion" with notifications set to "mentions only"
    When someone mentions me with "@john" in the group
    Then I should receive a mention notification
    And the notification should show the mention context
    And the notification should be prioritized over regular group messages

  Scenario: Manual do not disturb activation
    Given notifications are currently enabled
    When I manually activate do not disturb mode
    Then all notifications should be suppressed
    And I should see do not disturb indicator in the app
    And the mode should remain active until I turn it off

  Scenario: Scheduled do not disturb activation
    Given it's 10:00 PM and I have do not disturb scheduled for 10:00 PM - 8:00 AM
    Then do not disturb should automatically activate
    And I should see do not disturb indicator
    And all notifications should be suppressed until 8:00 AM

  Scenario: Notification history
    Given I received several notifications today
    When I check my notification history
    Then I should see all notifications from today
    And I should be able to mark notifications as read
    And I should be able to clear old notifications

  Scenario: Badge count updates
    Given I have unread messages
    When I receive a new message
    Then the app badge count should increase
    When I read a message
    Then the app badge count should decrease
    And the badge should disappear when all messages are read

  Scenario: Notification for message status updates
    Given I sent a message to "jane@example.com"
    And I have read receipts enabled for notifications
    When "jane@example.com" reads my message
    Then I should receive a subtle notification that my message was read
    And the notification should not be intrusive