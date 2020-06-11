(function () {

    require.config({
        paths: {
            'jquery': 'libs/jquery/dist/jquery.min',
            'underscore': 'libs/underscore/underscore',
            'http-requester': 'http-requester',
            'persister': 'persister',
            'validator': 'validator',
            'controller': 'controller'
        }
    });

    require(['controller', 'persister'], function (controller) {
        var controller = controller.init();
        controller.loadUI('#app-container');
    });

}());