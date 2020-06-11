var _ = require('underscore'),
  validator = require('../utils/validator');

module.exports = {
  normalizeKeys: function (api) {
    if (!(typeof api.namespace === 'string' && api.namespace.length)) {
      throw new Error('Namespace Required');
    }
    if (typeof api.path !== 'string') {
      throw new Error('Path Required');
    }

    if (api.path[api.path.length - 1] === '/') {
      api.path = api.path.slice(0, api.path.length - 1);
    }
    if (api.path[0] !== '/') {
      api.path = '/' + api.path;
    }

    if (!validator.namespace.test(api.namespace)) {
      throw new Error('Illegal Namespace');
    }
    if (!validator.path.test(api.path)) {
      throw new Error('Illegal Path');
    }
    return api;
  }
};
