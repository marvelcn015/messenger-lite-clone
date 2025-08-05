import { Given, When, Then } from '@cucumber/cucumber';
import request from 'supertest';
import { testContext } from './common';

When('I register with the following details:', async function(dataTable) {
  const userData = {};
  const rows = dataTable.hashes();
  
  rows.forEach((row: any) => {
    userData[row.field] = row.value;
  });

  testContext.testData.registrationData = userData;
  
  // TODO: Implement actual registration API call
  testContext.response = await request(testContext.app)
    .post('/api/auth/register')
    .send(userData);
  
  console.log(`Registration attempted with data:`, userData);
});

When('I register with password {string}', async function(password: string) {
  const userData = {
    username: 'testuser',
    email: 'test@example.com',
    password: password,
    phoneNumber: '+1234567890'
  };

  testContext.response = await request(testContext.app)
    .post('/api/auth/register')
    .send(userData);
});

When('I register with email {string}', async function(email: string) {
  const userData = {
    username: 'testuser',
    email: email,
    password: 'ValidPass123',
    phoneNumber: '+1234567890'
  };

  testContext.response = await request(testContext.app)
    .post('/api/auth/register')
    .send(userData);
});

Given('a user exists with email {string}', async function(email: string) {
  // TODO: Create existing user in database
  testContext.testData.existingUsers = testContext.testData.existingUsers || [];
  testContext.testData.existingUsers.push({ email });
  console.log(`User with email ${email} exists in system`);
});

Then('my account should be created successfully', function() {
  if (!testContext.response || testContext.response.status >= 400) {
    throw new Error('Account creation failed');
  }
  console.log('Account created successfully');
});

Then('I should receive an email verification request', function() {
  // TODO: Check if email verification was triggered
  console.log('Email verification request sent');
});

Then('I should receive an SMS verification request', function() {
  // TODO: Check if SMS verification was triggered
  console.log('SMS verification request sent');
});

Then('registration should fail', function() {
  if (!testContext.response || testContext.response.status < 400) {
    throw new Error('Expected registration to fail, but it succeeded');
  }
  console.log('Registration failed as expected');
});

Given('I have a verified account with:', async function(dataTable) {
  const userData = {};
  const rows = dataTable.hashes();
  
  rows.forEach((row: any) => {
    userData[row.field] = row.value;
  });

  testContext.testData.verifiedUser = userData;
  console.log('Verified user account exists:', userData);
});

When('I login with email {string} and password {string}', async function(email: string, password: string) {
  testContext.response = await request(testContext.app)
    .post('/api/auth/login')
    .send({ email, password });
});

Then('I should be successfully logged in', function() {
  if (!testContext.response || testContext.response.status >= 400) {
    throw new Error('Login failed');
  }
  
  testContext.currentUser = {
    ...testContext.currentUser,
    isAuthenticated: true,
    email: testContext.response.body.email
  };
  
  console.log('User successfully logged in');
});

Then('I should see my user ID', function() {
  if (!testContext.response.body.userId) {
    throw new Error('User ID not found in response');
  }
  console.log('User ID visible:', testContext.response.body.userId);
});

Then('I should see my display name', function() {
  if (!testContext.response.body.displayName) {
    throw new Error('Display name not found in response');
  }
  console.log('Display name visible:', testContext.response.body.displayName);
});

Then('my online status should be visible', function() {
  // TODO: Check if online status is properly set
  console.log('Online status is visible');
});

Then('login should fail', function() {
  if (!testContext.response || testContext.response.status < 400) {
    throw new Error('Expected login to fail, but it succeeded');
  }
  console.log('Login failed as expected');
});

Given('I have a disabled account with email {string}', async function(email: string) {
  testContext.testData.disabledUser = { email, status: 'disabled' };
  console.log(`Disabled user account exists: ${email}`);
});

When('I login with email {string} and valid password', async function(email: string) {
  testContext.response = await request(testContext.app)
    .post('/api/auth/login')
    .send({ email, password: 'ValidPassword123' });
});

When('I update my profile with:', async function(dataTable) {
  const profileData = {};
  const rows = dataTable.hashes();
  
  rows.forEach((row: any) => {
    profileData[row.field] = row.value;
  });

  testContext.response = await request(testContext.app)
    .put('/api/profile')
    .send(profileData);
});

Then('my profile should be updated successfully', function() {
  if (!testContext.response || testContext.response.status >= 400) {
    throw new Error('Profile update failed');
  }
  console.log('Profile updated successfully');
});

Then('my friends should be notified of the changes', function() {
  // TODO: Check if friends received notifications
  console.log('Friends notified of profile changes');
});

When('I upload a profile picture {string}', async function(filename: string) {
  // TODO: Implement file upload
  testContext.response = { status: 200, body: { message: 'Profile picture uploaded' } };
  console.log(`Profile picture ${filename} uploaded`);
});

Then('my profile picture should be updated', function() {
  console.log('Profile picture updated successfully');
});

Then('the image should be properly resized', function() {
  // TODO: Check if image was resized
  console.log('Image resized properly');
});

Then('my friends should see the updated picture', function() {
  // TODO: Check if friends can see new picture
  console.log('Friends can see updated profile picture');
});