/**
 * @api {get} /user/:account 1.用户名检测
 * @apiVersion 0.0.1
 * @apiName Check Account
 * @apiGroup User
 *
 * @apiDescription 检测用户名是否被占用
 *
 * @apiParam {String} account 用户名
 *
 * @apiExample 例子:
 * curl GET https://bunnydb.changeden.net/user/changeden
 *
 * @apiSuccess {Number} code  状态码
 * @apiSuccess {String} message 响应信息
 * @apiSuccess {Date} timeStamp 处理结束时间
 * @apiSuccess {Date} startTime 请求开始时间
 * @apiSuccess {Object} result 返回结果
 * @apiSuccess {String} result.account 用户名
 * @apiSuccess {Boolean} result.valid 用户名是否有效
 */
function checkUser() {
}

/**
 * @api {put} /user/ 2.注册
 * @apiVersion 0.0.1
 * @apiName Sign Up
 * @apiGroup User
 *
 * @apiDescription 用户注册
 *
 * @apiParam {String} account   用户名
 * @apiParam {String} password  用户密码
 * @apiParam {String} email  绑定邮箱
 * @apiParam {String} verificationCode  验证码
 *
 * @apiSuccess {Number} code  状态码
 * @apiSuccess {String} message 响应信息
 * @apiSuccess {Date} timeStamp 处理结束时间
 * @apiSuccess {Date} startTime 请求开始时间
 * @apiSuccess {Object} result 返回结果
 * @apiSuccess {String} result.account 用户名
 * @apiSuccess {String} result.userId 用户Id
 */
function signUp() {
}

/**
 * @api {post} /user/ 3.登录
 * @apiVersion 0.0.1
 * @apiName Sign In
 * @apiGroup User
 *
 * @apiDescription 用户登录
 *
 * @apiParam {String} account   用户名
 * @apiParam {String} password  用户密码
 *
 * @apiSuccess {Number} code  状态码
 * @apiSuccess {String} message 响应信息
 * @apiSuccess {Date} timeStamp 处理结束时间
 * @apiSuccess {Date} startTime 请求开始时间
 * @apiSuccess {Object} result 返回结果
 * @apiSuccess {Object} result.user 用户资料
 * @apiSuccess {String} result.user.userId 用户Id
 * @apiSuccess {String} result.user.account 用户名
 * @apiSuccess {Date} result.user.createAt 用户注册时间
 * @apiSuccess {Date} result.user.updateAt 用户资料更新时间
 * @apiSuccess {String} result.accessToken 应用操作权限
 */
function signIn() {
}