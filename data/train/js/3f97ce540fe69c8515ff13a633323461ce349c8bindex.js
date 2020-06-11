'use strict';

const when = require('when');

module.exports = ($, mixpanel, config) => {
  const HTTPService = require('./HTTPService')($, when, config);
  const SessionService = require('./SessionService')(HTTPService, when, config);
  const APIService = require('./APIService')($, HTTPService, SessionService);
  const MixpanelService = require('./MixpanelService')(mixpanel);
  const MobileService = require('./MobileService')();
  const SecureService = require('./SecureService')(mixpanel);
  const StripeService = require('./StripeService')($, APIService, SecureService, when, config);
  const URLService = require('./URLService')();
  const UserService = require('./UserService')(APIService, when, config);

  return {
    APIService: APIService,
    HTTPService: HTTPService,
    MixpanelService: MixpanelService,
    MobileService: MobileService,
    SessionService: SessionService,
    StripeService: StripeService,
    SecureService: SecureService,
    URLService: URLService,
    UserService: UserService
  };
};
