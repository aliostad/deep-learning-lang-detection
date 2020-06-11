define([
        'app/nav/models/NavModel',
        'app/nav/models/NavCollection',
        'app/nav/views/NavView',
        'app/nav/views/NavCollectionView'
    ],
    function () {
        //just namespacing
        var module = {
            models: {},
            views: {}
        }

        module.models.Nav = require('app/nav/models/NavModel');
        module.models.Navs = require('app/nav/models/NavCollection');
        module.views.Nav = require('app/nav/views/NavView');
        module.views.Navs = require('app/nav/views/NavCollectionView');

        return module;
    });