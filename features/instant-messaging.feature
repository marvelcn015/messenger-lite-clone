Feature: Instant Messaging
  As a user of the messenger application
  I want to send and receive messages
  So that I can communicate with my friends in real-time

  Background:
    Given the messenger application is running
    And I am logged in as user "john@example.com"
    And "jane@example.com" is my friend
    And "jane@example.com" is online

  Scenario: Send text message
    When I send a text message "Hello Jane!" to "jane@example.com"
    Then the message should be delivered
    And "jane@example.com" should receive the message "Hello Jane!"
    And I should see message status as "sent"
    And the message should have a timestamp

  Scenario: Send long text message
    When I send a text message with 2000 characters to "jane@example.com"
    Then the message should be delivered successfully

  Scenario: Prevent sending message exceeding character limit
    When I try to send a text message with 2001 characters
    Then the message should be rejected
    And I should see error "Message exceeds 2000 character limit"

  Scenario: Send message with emojis
    When I send a text message "Hello! 😊👋🎉" to "jane@example.com"
    Then the message should be delivered
    And the emojis should be properly displayed

  Scenario: Message status tracking
    When I send a message "Test message" to "jane@example.com"
    Then I should see status "sending"
    When the message is delivered to server
    Then I should see status "sent"
    When "jane@example.com" receives the message
    Then I should see status "delivered"
    When "jane@example.com" reads the message
    Then I should see status "read"

  Scenario: Edit message within time limit
    Given I sent a message "Hello Jane" 2 minutes ago
    When I edit the message to "Hello Jane, how are you?"
    Then the message should be updated
    And "jane@example.com" should see the edited message
    And the message should show "edited" indicator

  Scenario: Cannot edit message after time limit
    Given I sent a message "Hello Jane" 6 minutes ago
    When I try to edit the message
    Then the edit should be rejected
    And I should see error "Message can only be edited within 5 minutes"

  Scenario: Delete own message
    Given I sent a message "This is a test" to "jane@example.com"
    When I delete my message
    Then the message should be removed from the conversation
    And "jane@example.com" should see the message is deleted

  Scenario: Cannot delete other's message
    Given "jane@example.com" sent me a message "Hello John"
    When I try to delete the message
    Then the delete should be rejected
    And I should see error "You can only delete your own messages"

  Scenario: Send image message
    When I upload and send image "photo.jpg" (5MB) to "jane@example.com"
    Then the image should be compressed if needed
    And the image message should be delivered
    And "jane@example.com" should see the image with preview
    And the image should be downloadable

  Scenario: Send large image with compression
    When I upload and send image "large_photo.jpg" (15MB) to "jane@example.com"
    Then the image should be automatically compressed
    And the compressed image should be under 10MB
    And the message should be delivered

  Scenario: Reject oversized image
    When I try to upload image "huge_photo.jpg" (20MB)
    Then the upload should be rejected
    And I should see error "Image must be under 10MB"

  Scenario: Send file attachment
    When I upload and send file "document.pdf" (10MB) to "jane@example.com"
    Then the file should be uploaded
    And the file message should be delivered
    And "jane@example.com" should be able to download the file

  Scenario: Reject oversized file
    When I try to upload file "large_document.pdf" (30MB)
    Then the upload should be rejected
    And I should see error "File must be under 25MB"

  Scenario: Send voice message
    When I record and send a voice message (30 seconds) to "jane@example.com"
    Then the voice message should be uploaded
    And "jane@example.com" should receive the voice message
    And the voice message should be playable

  Scenario: Reject long voice message
    When I try to record a voice message longer than 60 seconds
    Then the recording should be stopped at 60 seconds
    And I should see warning "Voice message limited to 60 seconds"

  Scenario: View chat history
    Given I have previous conversations with "jane@example.com"
    When I open the chat with "jane@example.com"
    Then I should see our complete conversation history
    And messages should be sorted by timestamp
    And I should see message status for each message

  Scenario: Search messages in chat
    Given I have many messages in chat with "jane@example.com"
    When I search for "meeting" in our chat
    Then I should see all messages containing "meeting"
    And the search term should be highlighted

  Scenario: Load more chat history
    Given I have 1000+ messages with "jane@example.com"
    When I scroll up in the chat
    Then older messages should be loaded automatically
    And the chat should maintain scroll position

  Scenario: Offline message delivery
    Given "jane@example.com" is offline
    When I send a message "Offline message" to "jane@example.com"
    Then the message should be stored
    When "jane@example.com" comes online
    Then they should receive the "Offline message"

  Scenario: Message local storage
    Given I have been chatting with "jane@example.com" for 30 days
    When I open the chat
    Then I should see messages from the last 30 days stored locally
    And older messages should be retrievable from server