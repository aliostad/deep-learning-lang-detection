/**
 * @author: biangang
 * @date: 2014/4/16
 */
define([
    "backbone",
    "app/nav/collection/navItems",
    "app/nav/view/navItemView",
    "app/nav/view/navItemsView"
], function(Backbone, navItems, NavItemView, NavItemsView){
    "use strict";

    function Module(M, App){

        var navItemsView = new NavItemsView({
            collection: navItems
        });

        App.navRegion.show(navItemsView);

        M.updateCurrentNav = function(path){
            navItemsView.setCurrentNav(path);
        };
    }

    return Module;
});