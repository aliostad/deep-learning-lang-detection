/**
 * @api {get} /users/:id 사용자 조회
 * @apiHeader (User) {String} authorization Authorization value.
 * @apiHeaderExample {json} Header-Example:
 *  {
 *    "Authorization": "accessTokenId"
 *  } 
 * @apiVersion 0.1.0
 * @apiName GetUser
 * @apiGroup User
 * @apiPermission admin
 *
 * @apiDescription
 * Find a model instance by {{id}} from the data source.
 *
 * @apiParam {String} id 		   userId	.
 *
 * @apiSuccess {String} id         userId.
 * @apiSuccess {Date}   name       Fullname of the User.
 *
 * @apiError UserNotFound   The <code>id</code> of the User was not found.
 */


/**
 * @api {post} /users 사용자 회원가입
 * @apiVersion 0.1.0
 * @apiName PostUser
 * @apiGroup User
 * @apiPermission user
 *
 * @apiDescription
 * Create a new instance of the model and persist it into the data source.
 *
 * @apiParam {String} email  		user eamil.
 * @apiParam {String} email  		user password.
 *
 * @apiSuccess {String} id          userId.
 *
 * @apiUse CreateUserError
 */


 /**
 * @api {post} /users 사용자 로그인
 * @apiVersion 0.1.0
 * @apiName LoginUser
 * @apiGroup User
 * @apiPermission user
 *
 * @apiDescription
 * Login a user with username/email and password
 *
 * @apiParam {String} email  		user eamil.
 * @apiParam {String} email  		user password.
 *
 * @apiUse CreateUserError
 * @apiSuccess {String}	id         accessTokens.
 *
 */


 /**
 * @api {delete} /users 사용자 계정탈퇴
 * @apiVersion 0.1.0
 * @apiName DeleteUser
 * @apiGroup User
 * @apiPermission user
 *
 * @apiDescription
 * Delete a model instance by {{id}} from the data source.
 *
 * @apiParam {String} id 		   userId	.
 *
 * @apiError UserNotFound   The <code>id</code> of the User was not found.
 */
