exports.API_REST      = './api/rest';
exports.API_SOCKET_IO = './api/socket.io';
exports.API_GROONGA   = './api/groonga';
exports.API_DROONGA   = './api/droonga';

exports.exportTo = function(target) {
  target.API_REST      = exports.API_REST;
  target.API_SOCKET_IO = exports.API_SOCKET_IO;
  target.API_GROONGA   = exports.API_GROONGA;
  target.API_DROONGA   = exports.API_DROONGA;
};

exports.normalize = function(apis) {
  apis = apis || [];
  if (!Array.isArray(apis))
    apis = [apis];
  apis = apis.map(function(api) {
    if (typeof api == 'string')
      return require(api);
    else
      return api;
  });
  return apis;
};
