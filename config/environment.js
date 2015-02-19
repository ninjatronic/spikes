/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'spikes',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',

    contentSecurityPolicy: {
      'style-src': "'self' http://maxcdn.bootstrapcdn.com",
      'script-src': "'self' http://maxcdn.bootstrapcdn.com da189i1jfloii.cloudfront.net apis.google.com",
      'font-src': "'self' http://maxcdn.bootstrapcdn.com",
      'frame-src': "'self' accounts.google.com",
      'connect-src': "'self' https://baas.kinvey.com"
    },

    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
    ENV.APP.KINVEY_APP_ID = 'kid_Z1fO22y_s';
    ENV.APP.KINVEY_APP_SECRET = '74783fda6bb8472cb66af0ebc862eae9';
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    
    ENV.APP.KINVEY_APP_ID = 'kid_Z1fO22y_s';
    ENV.APP.KINVEY_APP_SECRET = '74783fda6bb8472cb66af0ebc862eae9';
  }

  if (environment === 'production') {
    ENV.APP.KINVEY_APP_ID = 'kid_Z1fO22y_s';
    ENV.APP.KINVEY_APP_SECRET = '74783fda6bb8472cb66af0ebc862eae9';
  }

  return ENV;
};
