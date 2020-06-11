// Module API Spec
// ---------------

var assert = require('assert');

var vk = require('..');

describe('API', function() {

  var apiId     = '4';
  var apiSecret = 'api_secret';

  it('signs the API requests correctly', function () {
    var vkAPI = new vk.API(apiId);

    var params = {
      'api_id' : apiId,
      'v'      : '3.0',
      'method' : 'getFriends',
    };

    var signature = vkAPI.sign(params, apiSecret);
    assert.equal(signature, 'fbd3bc00725799ecd835bf661391ac34');
  });

  it('can construct a signed query string', function () {
    var vkAPI = new vk.API(apiId);

    var params = {
      'api_id' : apiId,
      'v'      : '3.0',
      'method' : 'getFriends',
    };

    var qs = vkAPI.query(params, apiSecret);
    assert.equal(qs, 'api_id=4&v=3.0&method=getFriends&'
      + 'sig=fbd3bc00725799ecd835bf661391ac34');
  });

});
