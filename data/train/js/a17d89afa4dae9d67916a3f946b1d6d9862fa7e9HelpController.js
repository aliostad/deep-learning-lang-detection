Ext.define('TestMobile.controller.help.HelpController', {

    extend: 'Ext.app.Controller',

    config: {
        control: {
            help: {
                showLogin: 'onShowLogin',
                showThemeOption: 'onShowThemeView'
            }
        }
    },

    onShowLogin: function(){
        var tmpMainController = this.getMainController();
        tmpMainController.setRightAnimation();
        tmpMainController.showLoginView();
    },

    onShowThemeView: function(){
        var tmpMainController = this.getMainController();
        tmpMainController.showThemeView();
    },

    getMainController: function(){
        return this.getApplication().getController('MainController');
    }

});