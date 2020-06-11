define(['underscore', 'backbone',
        'library/CRMApp',
        'controller/LoginController',
        'controller/HomeController',
        'controller/ListController',
        'controller/FormController',
        //more controllers
        ],

function(_, Backbone, CRMApp,
        LoginController,
        HomeController,
        ListController,
        FormController
        //more controllers
        ) {

    var DEFAULT_TTL = 30 * 24 * 3600;
    
    if (typeof window.crm_controller_register != 'undefined') {
        return window.crm_controller_register;
    }

    var CRMControllerRegister = function() {
    
    };

    CRMControllerRegister.getInstance = function() {
            if(typeof window.crm_controller_register == 'undefined') {
                window.crm_controller_register = CRMControllerRegister;
                var that = window.crm_controller_register;
                that.initialize();
            }
            
            return window.crm_controller_register;
    };
    
    CRMControllerRegister.initialize = function() {

        var app = CRMApp.getInstance();
        _.extend(app, Backbone.Events);
       
        var login_controller = LoginController;
        app.on("login", function(parameters) {
            login_controller.index(parameters);
        });
       
        var home_controller = HomeController;
        app.on("home", function(parameters) {
            home_controller.index(parameters);
        });
       
        var list_controller = ListController;
        app.on("list", function(parameters) {
            list_controller.index(parameters);
        });
        
        var form_controller = FormController;
        app.on("form", function(parameters) {
            form_controller.index(parameters);
        });
        //more controllers
    };
    
    return CRMControllerRegister.getInstance();
});