"use strict";

var apiDocument = require('../../api/document');
var apiProject = require('../../api/project');

module.exports = function (router) {
    router.route('/project')
	.post(apiProject.create);
    router.route('/project/:projectId')
	.put(apiProject.update)
	.delete(apiProject.delete);

    router.route('/document/:projectId')
	.post(apiDocument.create);
    router.route('/document/:projectId/:documentId')
	.put(apiDocument.update)
	.delete(apiDocument.delete);

    return router;
};