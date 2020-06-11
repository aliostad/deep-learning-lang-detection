var classes = {};
classes.utils = require('./common/utils');
classes.ApiException = classes.utils.ApiException;
classes.GroupDocsSecurityHandler = require('./common/GroupDocsSecurityHandler');

classes.ApiClient = require('./common/ApiClient');
classes.AntApi = require('./apis/AntApi');
classes.AsyncApi = require('./apis/AsyncApi');
classes.ComparisonApi = require('./apis/ComparisonApi');
classes.DocApi = require('./apis/DocApi');
classes.MergeApi = require('./apis/MergeApi');
classes.MgmtApi = require('./apis/MgmtApi');
classes.PostApi = require('./apis/PostApi');
classes.SharedApi = require('./apis/SharedApi');
classes.SignatureApi = require('./apis/SignatureApi');
classes.StorageApi = require('./apis/StorageApi');
classes.SystemApi = require('./apis/SystemApi');

module.exports = classes;

if (process.browser){
	global.groupdocs = classes;
}

// exports.ApiException = require('./common/ApiException');
// exports.StorageApi = require('./apis/StorageApi');

// exports['groupdocs-javascript'] = classes;