define([], function() {
    App.Model.ToolbarModel = Backbone.Model.extend({
        defaults: {
            componentId: '',
            name: '-',
            icon: 'globe',
            showTitle : true,
            showCreate: true,
            showSave: false,
            showCancel : false,
            showRefresh: true,
            showSearch: true,
            showPrint: true,
            showButton1 : false,
            button1Name : '',
            button1EventName : '',
            showButton2 : false,
            button2sName : '',
            button2EventName : '',
            showComponentList : false
        },
        initialize: function() {

        }
    });
    return App.Model.ToolbarModel;
});