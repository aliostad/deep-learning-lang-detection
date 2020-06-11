/**
 * @api {get} api/user/ 取的所有用户信息
 * @apiName GetAllUser
 * @apiGroup User
 * @apiPermission login user
 * @apiSuccess {Number} id 用户id
 * @apiSuccess {String} name 用户姓名
 * @apiSuccess {Number} age 用户年龄
 *
 * @apiSuccessExample Success-Response
 *     HTTP/1.1 200 OK
 *	 [
 *	  {
 *	    "id": 1,
 *	    "name": "madidi",
 *	    "age": "18"
 *	  },
 *	  {
 *	    "id": 2,
 *	    "name": "cengjunjun",
 *	    "age": "19"
 *	  }
 *	]
 */


/**
 * @api {get} api/user/:id 取得指定id用户信息
 * @apiName GetTheUser
 * @apiGroup User
 * @apiPermission login user
 *
 * @apiParam {Number} id Users unique ID.
 * 
 * @apiSuccess {Number} id 用户id
 * @apiSuccess {String} name 用户姓名
 * @apiSuccess {Number} age 用户年龄
 *
 * @apiSuccessExample Success-Response
 *     HTTP/1.1 200 OK
 *	  {
 *	    "id": 1,
 *	    "name": "madidi",
 *	    "age": "18"
 *	  }
 *	  
 * @apiError 4xx
 * @apiError NoAccessRight  用户未登录
 * @apiError UserNotFound   没有该用户id
 *
 * @apiErrorExample {json} Error-Response
 *   HTTP/1.1 404 NOT FOUND
 *   {
 *    "error" : "UserNotFound"
 *   } 
 */
 
 
 /**
 * @api {post} api/user/ 创建一个新用户
 * @apiName create a new user
 * @apiGroup User
 * @apiPermission login user
 * 
 * @apiParam {String} name 用户姓名
 * @apiParam {Number} age 用户年龄
 *
 * @apiSuccess {Number} id 用户id
 *
 * @apiError 4xx
 * @apiError NoAccessRight  用户未登录
 * @apiError AgeIsNaN  年龄非数字
 * @apiError UserNameToolong 姓名少于四个字
 *
 */
 
/**
 * @api {put} api/user/:id 更新一个用户信息
 * @apiName update a  user info
 * @apiGroup User
 * @apiPermission login user
 * 
 * @apiParam {String} name 用户姓名
 * @apiParam {Number} age 用户年龄
 *
 *
 * @apiError 4xx
 * @apiError NoAccessRight  用户未登录
 * @apiError AgeIsNaN  年龄非数字
 * @apiError UserNameToolong 姓名少于四个字
 *
 */
