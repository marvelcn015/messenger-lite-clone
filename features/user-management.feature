Feature: User Management
  As a messenger application
  I want to manage user registration, authentication, and profiles
  So that users can securely access and use the messaging service

  Background:
    Given the messenger application is running
    And the database is clean

  Scenario: User registration with valid data
    Given I am a new user
    When I register with the following details:
      | field       | value            |
      | username    | john_doe         |
      | email       | john@example.com |
      | password    | SecurePass123    |
      | phoneNumber | +1234567890      |
    Then my account should be created successfully
      | field         | value            |
      | serial number | Integer          |
      | username      | john_doe         |
      | email         | john@example.com |
      | password      | SecurePass123    |
      | phoneNumber   | +1234567890      |
    And I should receive an email verification request
    And I should receive an SMS verification request

  Scenario: User registration with invalid password
    Given I am a new user
    When I register with password "weak"
    Then registration should fail
    And I should see error "Password must be at least 8 characters with alphanumeric characters"

  Scenario: User registration with duplicate email
    Given a user exists with email "john@example.com"
    When I register with email "john@example.com"
    Then registration should fail
    And I should see error "Email already registered"

  Scenario: User login with valid credentials
    Given I have a verified account with:
      | email    | john@example.com |
      | password | SecurePass123    |
    When I login with email "john@example.com" and password "SecurePass123"
    Then I should be successfully logged in
    And I should see my user ID
    And I should see my display name
    And my online status should be visible

  Scenario: User login with invalid credentials
    When I login with email "wrong@example.com" and password "wrongpass"
    Then login should fail
    And I should see error "Account does not exist or password is incorrect"

  Scenario: User login with disabled account
    Given I have a disabled account with email "disabled@example.com"
    When I login with email "disabled@example.com" and valid password
    Then login should fail
    And I should see error "Account is disabled"

  Scenario: User profile editing
    Given I am logged in as a user
    When I update my profile with:
      | field           | value        |
      | displayName     | John Updated |
      | statusMessage   | Busy at work |
      | privacySettings | friends_only |
    Then my profile should be updated successfully
    And my friends should be notified of the changes

  Scenario: User profile picture upload
    Given I am logged in as a user
    When I upload a profile picture "avatar.jpg"
    Then my profile picture should be updated
    And the image should be properly resized
    And my friends should see the updated picture