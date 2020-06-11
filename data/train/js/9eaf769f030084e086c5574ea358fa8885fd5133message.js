/**
 * message_routes.js
 */

'use strict';

var routeFindMiddleware = dependency('middleware', 'route_find');
var apiPath = dependency('lib', 'helpers').apiPath;

/**
 * Message routes
 * @param  {Object} app Express app
 */
module.exports = function(app, controller) {
    /**
     * @api {get} /messages/ Find Messages
     * @apiName FindMessages
     * @apiGroup Message
     * @apiPermission all
     *
     * @apiStructure ResourceFind
     *
     * @apiSuccess {Array}  messages       List of all the found messages
     * @apiErrorStructure ResourceError
     */
    app.get(apiPath('messages'), controller.find.bind(controller) );

    /**
     * @api {get} /messages/:_ids Retrieve Messages by id
     * @apiName RetrieveMessages
     * @apiGroup Message
     * @apiPermission all
     *
     * @apiStructure ResourceFindByIds
     *
     * @apiSuccess {Array}  messages       List of all the found messages
     * @apiErrorStructure ResourceError
     */
    app.get(apiPath('messages/:_ids'), routeFindMiddleware(controller));

    /**
     * @api {post} /messages/ Create Message
     * @apiName CreateMessage
     * @apiGroup Message
     * @apiPermission admin
     *
     * @apiParam {String} name     Name
     * @apiParam {String} slug     Slug
     *
     * @apiSuccess (201) {Array}  messages       The created message
     * @apiErrorStructure ResourceError
     */
    app.post(apiPath('messages'), controller.create.bind(controller) );

    /**
     * @api {put} /messages/:_id Update Message
     * @apiName UpdateMessage
     * @apiGroup Message
     * @apiPermission admin
     *
     * @apiSuccess {Array}  messages       The updated message
     * @apiErrorStructure ResourceError
     */
    app.put(apiPath('messages/:_id'), controller.update.bind(controller) );

    /**
     * @api {delete} /messages/:_id Delete Message
     * @apiName DeleteMessage
     * @apiGroup Message
     * @apiPermission admin
     *
     * @apiStructure ResourceDelete
     *
     * @apiErrorStructure ResourceError
     */
    app.delete(apiPath('messages/:_id'), controller.remove.bind(controller) );
};
