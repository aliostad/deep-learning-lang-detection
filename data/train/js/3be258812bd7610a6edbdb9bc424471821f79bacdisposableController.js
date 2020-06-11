trcraftingbuddy.factory('disposableController', [function()                     {
    return {
        create: function($scope, base)                                          {
            var controller                  = base || {};
            var events                      = [];
            var initialized                 = false;
            //
            controller.isInitialized        = function() { return initialized; };
            controller.init                 = function() { };
            controller.update               = true;
            controller.render               = function() { };
            controller.destroy              = function() { };
            controller.countEvents          = function() { return events?events.length:-1; };
            controller.addEventRemover      = function(remover) { events.push(remover); return remover };
            controller.removeEventRemover   = function(remover)                 {
                var index = events.indexOf(remover); if (index < 0) return;
                events.splice(index, 1);
            };
            //
            var updater                 = setInterval(function()                {
                if (!controller.update) return; controller.update   = false;
                if (!initialized && typeof controller.init == 'function')       {
                    initialized    = true;
                    controller.init();
                } 
                if (typeof controller.render == 'function') controller.render();
            }, 10);
            //
            events.push($scope.$on('$destroy', function()                       {
                if (updater >= 0) clearInterval(updater);
                //
                while (events.length) events.shift()();
                //
                if (controller.destroy && typeof controller.destroy === 'function') controller.destroy();
                //
                controller.update           = null;
                controller.init             = null;
                controller.countEvents      = null;
                controller.addEventRemover  = null;
                controller.destroy          = null;
                controller                  = null;
                events                      = null;
                initialized                 = null;
                updater                     = null;
            }));
            //
            return controller;
        }
    };
}]);
