
/**
 * @apiDefineStructure ApiAppStructure
 *
 * @apiParam {String} appName Name for API App. Apps that are clients of API such as: CSM, National and so on.
 * @apiParam {String} authKey This key must be put in headers when accessing to API's secured methods such as creating Provider, Client and so on. The way it should exists in header: header('authorization', 'Basic {authKey}') 
 * @apiParam {Boolean} [sysInfo_active=true] true is App should have access to API. false otherwise.
 */


/**
 * @api {post} /api/apiapps Create new API App
 * @apiName Create
 * @apiGroup ApiApps
 * @apiVersion 0.1.0
 * @apiDescription Creates new API App record in database. ApiApp's json must be send into request.body
 *
 * @apiStructure ApiAppStructure
 */


/**
 * @api {put} /api/apiapps/:id Updates a API App
 * @apiName Update
 * @apiGroup ApiApps
 * @apiVersion 0.1.0
 * @apiDescription Updates ApiApp's record in database. Authkey update is achieved by this method.
 *
 * @apiParam {String} id Id of user that will be updated.
 *
 * @apiExample Example of update of password: 
 *      PUT: http://staging.twc.bz/api/users/5231d52fdbe35aea7400000c
 *      BODY: {
 *              authKey: "test2"
 *      }
 *      response:
 *      {
 *          "success": true,
 *          "message": "Doc with id: 52360848e12d40d723000009 has successfully updated.",
 *          "result": {
 *              "__v": 0,
 *              "_id": "52360848e12d40d723000009",
 *              "appName": "CSM",
 *              "authKey": "ca10587c0232623281bb395c48c91e91",
 *              "sysInfo": {
 *                  "active": true
 *              }
 *          }
 *      }
 */

/**
 * @api {get} /api/apiapps/:id Returnes single API App
 * @apiName GetSingle
 * @apiGroup ApiApps
 * @apiVersion 0.1.0
 * @apiDescription Returnes single API App
 *
 * @apiParam {String} id Id of API App that will be returned.
 */


/**
 * @api {get} /api/apiapps Search
 * @apiName Search
 * @apiGroup ApiApps
 * @apiVersion 0.1.0
 * @apiDescription Get list of active API Apps.
 *  
 */

/**
 * @api {delete} /api/apiapps/:id Deletes API App
 * @apiName DELETE
 * @apiGroup ApiApps
 * @apiVersion 0.1.0
 * @apiDescription After deleting API App it will no longer have access to API's secured methods.
 *
 * @apiParam {String} id Id of API App that will be deleted.
 */

