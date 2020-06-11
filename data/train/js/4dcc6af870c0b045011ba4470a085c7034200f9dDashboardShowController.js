/*
 |------------------------------------------------------------------------------
 | Dashboard Show Controller                          DashboardShowController.js
 |------------------------------------------------------------------------------
 */
define(['msgbus', 'apps/dashboard/show/DashboardShowView'],
function (MsgBus, DashboardShowView) {

    var controller = {

        /**
         * Show Dashboard
         */
        show: function () {

            var regions = {
                content: new DashboardShowView(),
            };
            MsgBus.commands.execute('regions:load', regions);
        }
    };

    return controller;
});
