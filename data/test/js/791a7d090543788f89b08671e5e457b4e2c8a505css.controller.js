(function () {
    'use strict';

    angular
        .module('sample')
        .controller('CssController', CssController)
        .controller('CssViewController', CssViewController)
        .controller('CssEditController', CssEditController);

    /** @ngInject */
    function CssController(Css) {
        var vm = this;

    }

    /** @ngInject */
    function CssViewController($state, Css) {
        var vm = this;
    }

    /** @ngInject */
    function CssEditController($state, Css) {
        var vm = this;
    }
})();
