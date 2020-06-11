var requireDirectory = require('require-directory');
var controller = requireDirectory(module, '../server/controllers');

module.exports = [{
        method: 'GET',
        path: '/',
        config: controller.applicationController.index
    }, {
        method: 'GET',
        path: '/welcome',
        config: controller.applicationController.welcome
    }, {
        method: 'GET',
        path: '/images/{path*}',
        config: controller.assetsController.images
    }, {
        method: 'GET',
        path: '/stylesheets/{path*}',
        config: controller.assetsController.css
    }, {
        method: 'GET',
        path: '/javascripts/{path*}',
        config: controller.assetsController.js
    }, {
        method: 'GET',
        path: '/components/{path*}',
        config: controller.assetsController.bower
    }, {
        method: 'GET',
        path: '/dist/{path*}',
        config: controller.assetsController.dist
    }

];
