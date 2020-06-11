var config = require('./config');

var blobService = null;

function initializeBlobService(azure) {
   if (blobService == null) {
       var account = config.azure.storage_name;
       var access_key = config.azure.storage_key;
       blobService = azure.createBlobService(account, access_key);
    }
    return blobService;
};

function initializeContainer(container, callback) {
    if (blobService == null) {
	callback(new Error('Blob Service not initialized'));
    }
    blobService.createContainerIfNotExists(container, function(error) { callback(error); });
    return blobService;
};

function getBlobService() {
    if (blobService == null) { throw new Error('Blob Service not initialized'); }
    return blobService;
};

module.exports.initializeBlobService = initializeBlobService;
module.exports.initializeContainer = initializeContainer;
module.exports.getBlobService = getBlobService;


