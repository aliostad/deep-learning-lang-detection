defineModule(function(that) {

    var navView;

    that.on_knockout_taskerTemplateRendered = function() {
        that.require('views/NavView.js', function(NavView) {
            navView = NavView(helpers);
            that.doAction('renderKoTemplate', {name:'nav', to:'navigation', template:'templates/nav.html', viewModel:navView});
        });
    };


    that.on_knockout_navTemplateRendered = function(data) {
        that.fireEvent('ready');
    };

    that.do_addNavButton = function(data) {
        navView.buttons.push({text:data.text, action:data.action});
    };

    var helpers = {
        doAction:that.doAction
    };
});