var controller = require('../controller/controller');

module.exports = function (app) {

    // pre handle user
    //app.use(function (req, res, next) {
    //    var _user = req.session.user
    //
    //    app.locals.user = _user
    //
    //    next()
    //})

    app.get('/', controller.index);
    app.get('/login', controller.showLogin);
    app.get('/apply', controller.apply);
    app.post('/apply', controller.signinRequired, controller.saveApply);
    app.post('/user/signin', controller.signin);
    app.get('/user/logout', controller.logout);
    app.get('/user/msg', controller.userMsg);

    app.get('/admin', controller.adminRequired, controller.showAdmin);
    app.get('/admin/apply/num', controller.adminRequired, controller.applyNum);
    app.post('/admin/print', controller.adminRequired, controller.print);
    app.post('/admin/adduser', controller.adminRequired, controller.addUser);
    app.get('/admin/userlist', controller.adminRequired, controller.userList);
    app.post('/admin/getuserinfo', controller.adminRequired, controller.getUserInfo);
    app.post('/admin/updateuser', controller.adminRequired, controller.updateUser);
    app.get('/admin/resetapplies', controller.adminRequired, controller.resetApplies);
    app.get('/admin/deluser', controller.adminRequired, controller.delUser);

    app.get('/admin/apply/nonchecked', controller.adminRequired, controller.unCheckedApply);
    app.get('/admin/apply/checked', controller.adminRequired, controller.checkedApply);
    app.post('/admin/apply/agree', controller.adminRequired, controller.agreeApply);
    app.post('/admin/apply/disagree', controller.adminRequired, controller.disagreeApply);

    app.get('/admin/timectrl', controller.adminRequired, controller.timeCtrl);
    app.get('/admin/opentime', controller.adminRequired, controller.openTime);
    app.get('/admin/openplace', controller.adminRequired, controller.openPlace);
    app.get('/admin/saveplace', controller.adminRequired, controller.savePlace);
    app.get('/admin/delplace', controller.adminRequired, controller.delPlace);
}

