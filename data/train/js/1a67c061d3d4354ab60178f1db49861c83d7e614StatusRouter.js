/*jslint browser: true, devel: true, indent: 4, nomen:true, vars: true */
/*global define */

define(function (require, exports, module) {
    "use strict";

    var BaseRouter = require('./BaseRouter');

    var StatusRouter = BaseRouter.extend({
        
        routes: {
            '': 'showAll',
            'all': 'showAll',
            'room': 'showRoom',
            'hall': 'showHall',
            'booth': 'showBooth'
        },

        showAll: function () {
            this.page.trigger('showAll');
        },

        showRoom: function () {
            this.page.trigger('showRoom');
        },

        showHall: function () {
            this.page.trigger('showHall');
        },

        showBooth: function () {
            this.page.trigger('showBooth');
        }
    });
    
    return StatusRouter;
});
