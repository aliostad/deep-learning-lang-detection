define([
    'global',
    'marionette',
    'view/user/account',
    'view/error'
], function(
    global,
    Marionette,
    UserAccountView,
    ErrorView
) {
    'use strict';
    
    
    function showAccount ()
    {
        global.app.main.show(new UserAccountView({
            model: global.app.request('session:user')
        }));
    }
    
   
    function showError (route)
    {
        console.warn("Route not found: '"+ route + "'");
        global.app.main.show(new ErrorView({
            
        }));
    }
    
    
    return Marionette.Controller.extend({
        
        showAccount: showAccount,
        showError: showError
        
    });
});
