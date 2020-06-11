;(function(){ 'use strict';
    angular
        .module('mz.nav.services.api', [])
        .provider('mzNavApi', mzNavApi)
        .config(decorate)
        ;

    var required, navs, app;

    /* @ngInject */
    function mzNavApi(){
        var _this = this;
        function defaultConfig(){  this.hideOn = {};  this.showOn = {};  }

        this.config =
            { navBar : new defaultConfig()
            , left   : new defaultConfig()
            , right  : new defaultConfig()
            , footer : new defaultConfig()
            };
        this.hideOn = function(navType, state) {
            this.config[navType] ||( console.error('Nav type does not exist') );
            this.config[navType].hideOn[state] = true;   };

        this.$get = function($injector) {
            function Nav($NavService){  _.assign(this, _this.config);  this.config = _this.config;  };
            Nav.prototype.Nav = Nav;
            Nav.prototype.enable = function(scope) {};
            return $injector.instantiate(Nav);
            // return Nav
          }

      } // end function mzNavApi

    /* @ngInject */
    function decorate($provide) {
        $provide.decorator('mzNavApi', function ($delegate, $controller, $NavBarService){
            // $NavBarService.hideOn = $delegate.config.navBar.hideOn;
            return $delegate;
          });
      }

  }).call(this);
