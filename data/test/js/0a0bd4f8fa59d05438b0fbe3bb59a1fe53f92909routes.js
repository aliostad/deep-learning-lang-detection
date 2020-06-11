
module.exports.routes = {
  'post /frontdoor/enter': 'FrontdoorController.enter',
  'post /frontdoor/leave': 'FrontdoorController.leave',
  'post /frontdoor/cross': 'FrontdoorController.cross',

  'post /login': 'AuthenticateController.login',
  'post /authenticate': 'AuthenticateController.authenticate',

  'put  /flashband/:tag/block': 'FlashbandController.block',
  'get  /flashband/summary':    'FlashbandController.summary',
  'post /flashband/enable':     'FlashbandController.enable',

  'post /showgoer':         'ShowgoerController.create',
  'get  /showgoer':         'ShowgoerController.find',
  'get  /showgoer/search':  'ShowgoerController.search',
  'get  /showgoer/summary': 'ShowgoerController.summary',
  'post /showgoer/:showgoerId/associate/:tag': 'ShowgoerController.associate'
};
