/**
 * Created with JetBrains WebStorm.
 * User: NBE01
 * Date: 14-3-9
 * Time: 下午4:53
 * To change this template use File | Settings | File Templates.
 */

var logger = require('./../common/log').getLogger();
var Constant = require('./../common/Constant');
var CategoryService = require('./CategoryService');
var UserService = require('./UserService');
var BoardService = require('./BoardService');
var PostService = require('./PostService');
var SdkPostService = require('./PostSdkService');
var UploadPicService = require('./UploadPicService');
module.exports = function (app) {

    logger.info('init service.................................');
    var daoFactory = app.get(Constant.DAO_FACTORY);

    var ServiceFactory = {};

    if (!ServiceFactory[Constant.SERVICE_BOARD]) {
        BoardService.init(daoFactory);
        ServiceFactory[Constant.SERVICE_BOARD] = BoardService;
    }

    if (!ServiceFactory[Constant.SERVICE_CATEGORY]) {
        CategoryService.init(daoFactory);
        ServiceFactory[Constant.SERVICE_CATEGORY] = CategoryService;
    }

    if (!ServiceFactory[Constant.SERVICE_POST]) {
        PostService.init(daoFactory);
        ServiceFactory[Constant.SERVICE_POST] = PostService;
    }

    if(!ServiceFactory[Constant.SERVICE_SDK_POST]){
        SdkPostService.init(daoFactory);
        ServiceFactory[Constant.SERVICE_SDK_POST] = SdkPostService;
    }


    if (!ServiceFactory[Constant.SERVICE_USER]) {
        UserService.init(daoFactory);
        ServiceFactory[Constant.SERVICE_USER] = UserService;
    }

    if(!ServiceFactory[Constant.SERVICE_UPLOAD_PIC]){
        UploadPicService.init(app.get('ctx'),app.get('delimiter'),app.locals.appLocal);
        ServiceFactory[Constant.SERVICE_UPLOAD_PIC] = UploadPicService;
    }



    logger.info('init service complete.................................');
    return ServiceFactory;

};
