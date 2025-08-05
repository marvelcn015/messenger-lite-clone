import { Given, When, Then, Before, After, setDefaultTimeout } from '@cucumber/cucumber';
import request from 'supertest';
import app from '../src/app';

setDefaultTimeout(10000);

interface TestContext {
  app: any;
  response: any;
  currentUser: any;
  testData: any;
}

const testContext: TestContext = {
  app: null,
  response: null,
  currentUser: {},
  testData: {}
};

Before(function() {
  testContext.app = app;
  testContext.response = null;
  testContext.currentUser = {};
  testContext.testData = {};
});

After(function() {
  // Cleanup after each test
});

Given('the messenger application is running', async function() {
  testContext.app = app;
  const response = await request(testContext.app).get('/health');
  if (response.status !== 200) {
    throw new Error('Application is not running properly');
  }
});

Given('the database is clean', async function() {
  // TODO: Clean database before test
  console.log('Database cleanup - to be implemented');
});

Given('I am logged in as user {string}', async function(email: string) {
  testContext.currentUser = {
    email: email,
    id: `user_${Date.now()}`,
    isAuthenticated: true
  };
  console.log(`User ${email} is now logged in`);
});

Given('I am a new user', function() {
  testContext.currentUser = {
    isNew: true,
    isAuthenticated: false
  };
});

Then('I should see error {string}', function(expectedError: string) {
  if (!testContext.response) {
    throw new Error('No response available to check error');
  }
  
  const responseBody = testContext.response.body || testContext.response;
  const actualError = responseBody.error || responseBody.message;
  
  if (actualError !== expectedError) {
    throw new Error(`Expected error "${expectedError}" but got "${actualError}"`);
  }
});

export { testContext };