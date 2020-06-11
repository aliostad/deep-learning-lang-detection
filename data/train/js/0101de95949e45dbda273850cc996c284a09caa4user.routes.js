/**
 *
 * Created by Frank on 15/6/26.
 */
'use strict';
var auth = require('../../middleware/auth');
var user = require('../../api/v1/user.api');

module.exports = function (api) {

    /**
     * @apiDefine ClientRequestError
     * @apiError {String} error 错误信息
     *
     */


    /**
     * @api {get} /api/v1/profile 获取当前用户信息
     * @apiName GetUserProfile
     * @apiGroup User
     * @apiVersion 0.0.1
     * @apiHeader {String} Authorization Json web token
     * @apiPermission 认证用户
     *
     * @apiSuccess {String} _id 用户ID
     * @apiSuccess {String} username 用户名
     * @apiSuccess {String} displayName 真实姓名
     * @apiSuccess {String} gender 性别
     * @apiSuccess {String} avatar 用户头像URL (相对URL)
     * @apiSuccess {String} phone 用户电话
     * @apiSuccess {String} parent 家长名字
     * @apiSuccess {String} onSchool 用户所在公办学校
     * @apiSuccess {String} grade 年级
     * @apiSuccess {Number} finishedHomeworkCount 完成作业数
     * @apiSuccess {Number} finishedPreviewsCount 完成预习数
     *
     * @apiUse ClientRequestError
     *
     *
     */
    api.get('/profile', auth.getUserByToken, user.profile);


    /**
     * @api {post} /api/v1/public/bind 微信绑定
     * @apiName BindWeixin
     * @apiGroup User
     * @apiVersion 0.0.1
     * @apiPermission public
     * @apiParam {string} username 用户名
     * @apiParam {String} password 密码
     * @apiParam {String} code 微信验证码
     * @apiUse ClientRequestError
     * @apiSuccess {String} response Json web token
     * @apiSuccessExample 成功响应示例
     *     HTTP/1.1 200 OK
     *     xxxxxx
     *
     */
    api.post('/public/bind', user.bind);


    /**
     * @api {post} /api/v1/unbind 解除绑定
     * @apiName BindWeixin
     * @apiGroup User
     * @apiVersion 0.0.1
     * @apiPermission public
     * @apiUse ClientRequestError
     * @apiSuccess {String} response Json web token
     * @apiSuccessExample 成功响应示例
     *     HTTP/1.1 200 OK
     *
     */
    api.post('/unbind', user.unbind);

    /**
     * @api {get} /api/v1/public/auth 微信认证
     * @apiName AuthWeixin
     * @apiGroup User
     * @apiVersion 0.0.1
     * @apiPermission public
     * @apiParam {String} code 微信验证码
     * @apiUse ClientRequestError
     * @apiSuccess {String} response Json web token
     * @apiSuccessExample 成功响应示例
     *     HTTP/1.1 200 OK
     *     xxxxxx
     *
     */
    api.get('/public/auth', auth.getOpenidToken, user.auth);


    /**
     * @api {put} /api/v1/profile 修改当前用户信息
     * @apiName UpdateUserProfile
     * @apiGroup User
     * @apiVersion 0.0.1
     * @apiHeader {String} Authorization Json web token
     * @apiPermission 认证用户
     *
     * @apiParam {String} displayName 真实姓名
     * @apiParam {String} gender 性别
     * @apiParam {String} phone 用户电话
     * @apiParam {String} parent 家长名字
     * @apiParam {String} onSchool 用户所在公办学校
     * @apiParam {String} grade 年级
     *
     * @apiUse ClientRequestError
     * @apiSuccessExample 成功响应示例
     *     HTTP/1.1 200 OK
     *
     *
     */
    api.put('/profile', user.update);

    /**
     * @api {put} /api/v1/avatar 修改当前用户头像
     * @apiName UpdateUserAvatar
     * @apiGroup User
     * @apiVersion 0.0.1
     * @apiHeader {String} Authorization Json web token
     * @apiPermission 认证用户
     *
     * @apiParam {String} avatar 头像mediaId
     *
     * @apiUse ClientRequestError
     * @apiSuccessExample 成功响应示例
     *     HTTP/1.1 200 OK
     *
     *
     */
    api.put('/avatar', user.avatar);


    api.post('/public/qn/avatarUploaded', user.avatarUploaded);


};
