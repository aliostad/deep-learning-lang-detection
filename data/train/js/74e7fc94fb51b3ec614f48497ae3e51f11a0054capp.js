console = console || {log: function(){}, error: function(){}};

//somehow check what api is currently used HERE
var api = 'vk';

requirejs.config({
    baseUrl: 'js',
    shim: {
        'lib/backbone.localstorage': {
            deps: ['lib/backbone']
        },
        'lib/backbone': {
            deps: ['lib/underscore', 'lib/zepto', 'lib/functions'],
            exports: 'Backbone'
        },
        'lib/underscore': {
            exports: '_'
        },
        'lib/zepto': {
            exports: 'Zepto'
        }
    },
    //API overrides
    paths: {
        'api/Api': 'api/'+api+'/Api',
        'api/UsersApi': 'api/'+api+'/UsersApi',
        'api/FriendsApi': 'api/'+api+'/FriendsApi',
        'api/PhotosApi': 'api/'+api+'/PhotosApi'
    }
});

requirejs(['pages/ControlsPage', 'pages/RequestsPage', 'pages/ApiPage'], function ()
{
    requirejs(['router', 'views/MenuView']);
});