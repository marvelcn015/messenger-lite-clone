module.exports = {
  default: {
    require: [
      'step-definitions/**/*.ts'
    ],
    requireModule: [
      'ts-node/register'
    ],
    format: [
      'progress-bar',
      'html:reports/cucumber-report.html',
      'json:reports/cucumber-report.json'
    ],
    paths: [
      'features/**/*.feature'
    ],
    parallel: 1
  }
};