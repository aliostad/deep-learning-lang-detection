var myService = cordova.require('com.red_folder.phonegap.plugin.backgroundservice.BackgroundService');

document.addEventListener('deviceready', function() {
    AndroidService.getStatusStart();
}, true);

AndroidService = function() {};

AndroidService.handleSuccess = function(data) {
    AndroidService.updateView(data);
};

AndroidService.handleError = function(data) {
    //alert("Error: " + data.ErrorMessage);
    //alert(JSON.stringify(data));
    AndroidService.updateView(data);
};

AndroidService.getStatusStart=function() {
    myService.getStatus(function(r) {
            if (!r.ServiceRunning) {
                AndroidService.startService();
                setTimeout(function() { AndroidService.getStatusStart(); },5000); //in five secs, we retry
            } else {
                //its already running, great.
                if (r.TimerEnabled) {
                    AndroidService.disableTimer(); //timer should not be on.
                    setTimeout(function() { AndroidService.getStatusStart(); },5000); //in five secs, we retry
                } else {
                    //timer is ok.
                    if (!r.RegisteredForBootStart) {
                        AndroidService.registerForBootStart();
                        setTimeout(function() { AndroidService.getStatusStart(); },5000); //in five secs, we retry
                    } else {
                        AndroidService.setConfig();
                        AndroidService.handleSuccess(r);
                    }
                }
            }
        },
        function(e) {
            AndroidService.handleError(e)
        });

};

/*
 * Button Handlers
 */
AndroidService.getStatus = function() {
    myService.getStatus(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.startService = function() {
    myService.startService(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.stopService=function() {
    myService.stopService(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.enableTimer=function() {
    myService.enableTimer(60000,
        function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.disableTimer = function() {
    myService.disableTimer(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.registerForBootStart = function() {
    myService.registerForBootStart(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.deregisterForBootStart = function() {
    myService.deregisterForBootStart(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.registerForUpdates=function() {
    myService.registerForUpdates(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.deregisterForUpdates=function() {
    myService.deregisterForUpdates(function(r) {
            AndroidService.handleSuccess(r)
        },
        function(e) {
            AndroidService.handleError(e)
        });
};

AndroidService.setConfig = function() {

    messengerStorage.getLocalGroups(function(groups) {
        var config = {
            "pubKey": messageService.publishKey,
            "subscribeKey": messageService.subscribeKey,
            "groups": groups
        };
        myService.setConfiguration(config,
            function(r) {
                AndroidService.handleSuccess(r)
            },
            function(e) {
                AndroidService.handleError(e)
            });

    });
    AndroidService.getStatus();

};

/*
 * View logic
 */
AndroidService.updateView = function(data) {

};

