/**
 * channel_routes.js
 */

'use strict';

var routeFindMiddleware = dependency('middleware', 'route_find');
var apiPath = dependency('lib', 'helpers').apiPath;

/**
 * Channel routes
 * @param  {Object} app Express app
 */
module.exports = function(app, controller) {
    /**
     * @api {get} /channels/ Find Channels
     * @apiName FindChannels
     * @apiGroup Channel
     * @apiPermission all
     *
     * @apiStructure ResourceFind
     *
     * @apiSuccess {Array}  channels       List of all the found channels
     * @apiErrorStructure ResourceError
     */
    app.get(apiPath('channels'), controller.find.bind(controller) );

    /**
     * @api {get} /channels/:_ids Retrieve Channels by id
     * @apiName RetrieveChannels
     * @apiGroup Channel
     * @apiPermission all
     *
     * @apiStructure ResourceFindByIds
     *
     * @apiSuccess {Array}  channels       List of all the found channels
     * @apiErrorStructure ResourceError
     */
    app.get(apiPath('channels/:_ids'), routeFindMiddleware(controller));

    /**
     * @api {post} /channels/ Create Channel
     * @apiName CreateChannel
     * @apiGroup Channel
     * @apiPermission admin
     *
     * @apiParam {String} name     Name
     * @apiParam {String} slug     Slug
     *
     * @apiSuccess (201) {Array}  channels       The created channel
     * @apiErrorStructure ResourceError
     */
    app.post(apiPath('channels'), controller.create.bind(controller) );

    /**
     * @api {put} /channels/:_id Update Channel
     * @apiName UpdateChannel
     * @apiGroup Channel
     * @apiPermission admin
     *
     * @apiSuccess {Array}  channels       The updated channel
     * @apiErrorStructure ResourceError
     */
    app.put(apiPath('channels/:_id'), controller.update.bind(controller) );

    /**
     * @api {delete} /channels/:_id Delete Channel
     * @apiName DeleteChannel
     * @apiGroup Channel
     * @apiPermission admin
     *
     * @apiStructure ResourceDelete
     *
     * @apiErrorStructure ResourceError
     */
    app.delete(apiPath('channels/:_id'), controller.remove.bind(controller) );
};
