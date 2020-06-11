/**
 * Created by Rube on 15/2/15.
 */
var Api = require('../models/index').apidata;

var insertApi = function (doc, apiContent, callback) {
  var api = new Api();
  api.doc = doc;
  api.api = apiContent;
  api.markModified('doc');
  api.markModified('api');
  api.save(callback);
};

var delApi = function (id, callback) {
  Api.remove({_id: id}, callback);
};

var changeApi = function (id, doc, apiContent, callback) {
  Api.findOne({_id:id}, function(err, apiEntity){
    if (err){
      return callback(err);
    }
    if (apiEntity) {
      apiEntity.doc = doc;
      apiEntity.api = apiContent;
      apiEntity.markModified('doc');
      apiEntity.markModified('api');
      return apiEntity.save(callback);
    }
    callback(true);
  });
};

var findAllApi = function(callback){
  Api.find({}, callback);
};

exports.insertApi = insertApi;
exports.delApi = delApi;
exports.changeApi = changeApi;
exports.findAllApi = findAllApi;