Feature: Group Chat
  As a user of the messenger application
  I want to create and participate in group chats
  So that I can communicate with multiple people simultaneously

  Background:
    Given the messenger application is running
    And I am logged in as user "john@example.com"
    And I have friends "jane@example.com", "bob@example.com", and "alice@example.com"

  Scenario: Create a new group chat
    When I create a group chat with:
      | name        | Team Discussion      |
      | description | Our project team     |
      | members     | jane@example.com, bob@example.com |
    Then the group should be created successfully
    And I should be the group administrator
    And "jane@example.com" and "bob@example.com" should be added to the group
    And all members should receive group creation notifications

  Scenario: Create group with minimum members
    When I create a group chat with members "jane@example.com" and "bob@example.com"
    Then the group should be created successfully
    And the group should have 3 members total (including me)

  Scenario: Cannot create group with insufficient members
    When I try to create a group chat with only "jane@example.com"
    Then group creation should fail
    And I should see error "Group requires at least 2 other members"

  Scenario: Cannot exceed maximum group size
    Given I try to create a group with 51 members
    Then group creation should fail
    And I should see error "Group cannot exceed 50 members"

  Scenario: Send message in group chat
    Given I am in a group chat "Team Discussion" with "jane@example.com" and "bob@example.com"
    When I send message "Hello everyone!" to the group
    Then all group members should receive the message
    And the message should show my name as sender
    And the message should have group context

  Scenario: Mention specific group member
    Given I am in a group chat with "jane@example.com" and "bob@example.com"
    When I send message "@jane How's the project going?"
    Then "jane@example.com" should receive a mention notification
    And the message should highlight the mention
    And other members should see the message normally

  Scenario: Reply to specific message in group
    Given "jane@example.com" sent message "The meeting is at 3 PM" in our group
    When I reply to that message with "I'll be there"
    Then my reply should be linked to the original message
    And all group members should see the reply context
    And "jane@example.com" should receive a reply notification

  Scenario: Add member to existing group
    Given I am admin of group "Team Discussion"
    And "alice@example.com" is not in the group
    When I add "alice@example.com" to the group
    Then "alice@example.com" should be added to the group
    And all members should be notified of the new addition
    And "alice@example.com" should see recent group history

  Scenario: Remove member from group (as admin)
    Given I am admin of group "Team Discussion"
    And "bob@example.com" is a group member
    When I remove "bob@example.com" from the group
    Then "bob@example.com" should be removed from the group
    And remaining members should be notified
    And "bob@example.com" should lose access to the group

  Scenario: Cannot remove member (insufficient permissions)
    Given I am a regular member of group "Team Discussion"
    And "bob@example.com" is also a member
    When I try to remove "bob@example.com" from the group
    Then the removal should fail
    And I should see error "Only administrators can remove members"

  Scenario: Change group name (as admin)
    Given I am admin of group "Team Discussion"
    When I change the group name to "Project Alpha Team"
    Then the group name should be updated
    And all members should be notified of the name change
    And the change should be logged in group history

  Scenario: Change group description (as admin)
    Given I am admin of group "Team Discussion"
    When I change the group description to "Alpha project development team"
    Then the group description should be updated
    And all members should see the new description

  Scenario: Set group privacy to private
    Given I am admin of group "Team Discussion"
    When I set the group privacy to "private"
    Then the group should not appear in public searches
    And only invited members can join

  Scenario: Promote member to admin
    Given I am admin of group "Team Discussion"
    And "jane@example.com" is a regular member
    When I promote "jane@example.com" to administrator
    Then "jane@example.com" should have admin privileges
    And all members should be notified of the promotion

  Scenario: Leave group voluntarily
    Given I am a member of group "Team Discussion"
    When I leave the group
    Then I should be removed from the group
    And other members should be notified I left
    And I should lose access to the group

  Scenario: Admin cannot leave group with other members
    Given I am the only admin of group "Team Discussion" with other members
    When I try to leave the group
    Then I should see warning "Promote another admin before leaving"
    And the leave action should be blocked

  Scenario: Delete group (as admin)
    Given I am admin of group "Team Discussion"
    When I delete the group
    Then the group should be permanently deleted
    And all members should be notified
    And the group chat history should be archived

  Scenario: View group member list
    Given I am in group "Team Discussion" with multiple members
    When I view the group member list
    Then I should see all group members
    And I should see their online status
    And I should see admin indicators
    And I should see member join dates

  Scenario: Configure group notifications
    Given I am in group "Team Discussion"
    When I set group notifications to "mentions only"
    Then I should only receive notifications when mentioned
    And regular group messages should not notify me
    But I should still see the messages when I open the chat

  Scenario: Mute group notifications
    Given I am in group "Team Discussion"
    When I mute group notifications
    Then I should not receive any notifications from the group
    But messages should still be delivered
    And I should see unread message count

  Scenario: Send media in group chat
    Given I am in group "Team Discussion"
    When I send an image "team_photo.jpg" to the group
    Then all group members should receive the image
    And the image should be accessible to all members
    And the media should be stored in group shared storage