/**
 * @file index.js
 * @author sekiyika (px.pengxing@gmail.com)
 * @description
 *
 */

module.exports = function (app) {


    var StaticController = require('./staticController')(app);
    var DynamicController = require('./dynamicController')(app);

    var defaultController = require('./defaultController')(app);
    var RedirectController = defaultController.RedirectController;
    var NotFoundController = defaultController.NotFoundController;
    var InternalErrorController = defaultController.InternalErrorController;
    var EmptyController = defaultController.EmptyController;

    app.on('controller:request', handle);
    app.on('controller:404', handle404);
    app.on('controller:500', handle500);
    app.on('controller:redirect', handleRedirect);
    app.on('controller:static', handleStatic);
    app.on('controller:dynamic', handleDynamic);
    app.on('controller:empty', handleEmpty);

    /**
     * 处理所有请求的入口
     *
     * @param {http.ClientRequest} req request
     * @param {http.ServerResponse} res response
     * @param {Function} next next of connect
     */
    function handle(req, res, next) {
        var route = req.route;

        app.logger.dProfile('Controller:total - ' + req.pvid);

        if (!route) {
            app.emit('controller:404', req, res, next);
        } else {
            var options = route.options;

            // 判断是否为静态文件
            if (options.type === 'static') {
                // 即为静态文件的route
                app.emit('controller:static', req, res, next);
            } else if (options.redirect) {
                app.emit('controller:redirect', req, res, next);
            } else if (options.controller) {
                // 动态请求，需要识别controller和action
                app.emit('controller:dynamic', req, res, next);
            } else if (options.middlewares && options.middlewares.length > 0) {
                // 不走controller，只有middleware
                app.emit('controller:empty', req, res, next);
            } else {
                app.emit('controller:404', req, res, next);
            }

        }

    }

    function handle404(req, res, next) {
        var controller = new NotFoundController(req, res, next);
        controller.exec();
    }

    function handle500(err, req, res, next) {
        var controller = new InternalErrorController(err, req, res, next);
        controller.exec();
    }

    function handleRedirect(req, res, next) {
        var controller = new RedirectController(req, res, next);
        controller.exec();
    }

    function handleStatic(req, res, next) {
        var controller = new StaticController(req, res, next);
        controller.exec();
    }

    function handleEmpty(req, res, next) {
        var controller = new EmptyController(req, res, next);
        controller.exec();
    }

    function handleDynamic(req, res, next) {
        var controller = new DynamicController(req, res, next);
        controller.on('controller:dynamic:notFound', function (req, res, next) {
            app.emit('controller:404', req, res, next);
        });
        controller.exec();
    }

};
