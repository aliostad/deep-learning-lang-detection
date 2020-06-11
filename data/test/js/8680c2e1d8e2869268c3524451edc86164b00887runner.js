/**
 * Created by root on 3/11/15.
 */
function Runner() {}

var configuration = {
    'login': {
        'controller': {
            'file': 'loginController.js'
        }
    },
    'register': {
        'controller': {
            'file': 'registerController.js'
        }
    },
    'announce': {
        'controller': {
            'file': 'announceController.js'
        }
    },
    'home': {
        'controller': {
            'file': 'homeController.js'
        }
    },
    'account': {
        'controller': {
            'file':'accountController.js'
        }
    },
    'announceBid': {
        'controller': {
            'file':'bidController.js'
        }
    }
};

Runner.run = function () {
    var appName = $('app').attr('name');

    require(['/js/controller/' + configuration[appName].controller.file], function (Controller) {
        var appController = new Controller();
        appController.start();
    });


};