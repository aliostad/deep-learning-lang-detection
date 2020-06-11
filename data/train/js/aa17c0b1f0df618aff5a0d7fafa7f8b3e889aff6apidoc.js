/**
 * @api {{{method}}} {{url}} {{api_name}}
 * @apiName {{method}}/{{api_name}}
 * @apiGroup {{api_group}}
 * @apiDescription {{api_description}}
 *
 *
 {{api_headers}}
 * 
 {{api_params}}
 *
 * @apiSuccess {Bool} success true
 * @apiSuccess {Number} code Response code
 * @apiSuccess {Array} error Empty array
 * @apiSuccess {Object} data object
 *
 * @apiError (xxx) {Bool} success false
 * @apiError (xxx) {Number} code Response code
 * @apiError (xxx) {Array} error key value array of errors
 * @apiError (xxx) {Object} data empty object
 *
 * @apiError (404) {NotFound} 404 Not found.
 * @apiError (405) {MethodNotAllowed} 405 When accessing method that's not allowed
 *
 * @apiSuccessExample {json} Success Response Example
 * {{api_success}}
 *
 *
 * @apiErrorExample {json} Error Response Example:
 *
 * {{api_error}}
 *
 *
 */