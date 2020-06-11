/**
 * team_routes.js
 */

'use strict';

var routeFindMiddleware = dependency('middleware', 'route_find');
var apiPath = dependency('lib', 'helpers').apiPath;

/**
 * Team routes
 * @param  {Object} app Express app
 */
module.exports = function(app, controller) {
    /**
     * @api {get} /teams/ Find Teams
     * @apiName FindTeams
     * @apiGroup Team
     * @apiPermission all
     *
     * @apiStructure ResourceFind
     *
     * @apiSuccess {Array}  teams       List of all the found teams
     * @apiErrorStructure ResourceError
     */
    app.get(apiPath('teams'), controller.find.bind(controller) );

    /**
     * @api {get} /teams/:_ids Retrieve Teams by id
     * @apiName RetrieveTeams
     * @apiGroup Team
     * @apiPermission all
     *
     * @apiStructure ResourceFindByIds
     *
     * @apiSuccess {Array}  teams       List of all the found teams
     * @apiErrorStructure ResourceError
     */
    app.get(apiPath('teams/:_ids'), routeFindMiddleware(controller));

    /**
     * @api {post} /teams/ Create Team
     * @apiName CreateTeam
     * @apiGroup Team
     * @apiPermission admin
     *
     * @apiParam {String} name     Name
     * @apiParam {String} slug     Slug
     *
     * @apiSuccess (201) {Array}  teams       The created team
     * @apiErrorStructure ResourceError
     */
    app.post(apiPath('teams'), controller.create.bind(controller) );

    /**
     * @api {put} /teams/:_id Update Team
     * @apiName UpdateTeam
     * @apiGroup Team
     * @apiPermission admin
     *
     * @apiSuccess {Array}  teams       The updated team
     * @apiErrorStructure ResourceError
     */
    app.put(apiPath('teams/:_id'), controller.update.bind(controller) );

    /**
     * @api {delete} /teams/:_id Delete Team
     * @apiName DeleteTeam
     * @apiGroup Team
     * @apiPermission admin
     *
     * @apiStructure ResourceDelete
     *
     * @apiErrorStructure ResourceError
     */
    app.delete(apiPath('teams/:_id'), controller.remove.bind(controller) );
};
