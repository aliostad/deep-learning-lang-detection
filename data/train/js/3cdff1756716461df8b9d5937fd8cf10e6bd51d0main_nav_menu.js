import './main_nav_menu.html';
import './main_nav_menu.css';

import {Template} from 'meteor/templating';
import {Session} from 'meteor/session';

/**
 * Template helpers
 */
Template.MainNavMenu.helpers({
  navTitle() {
    return Session.get("navTitle")
  }
});

/**
 * Template rendered
 */
Template.MainNavMenu.rendered = function () {
  var instance = Template.instance();

  if(!instance._init){
    instance._init = true;

    // setup the nav menu controller
    instance.$(".nav-logo-bar")
      .on("mouseenter", function () {
        let navBody = $(".nav-body");
        $(".main-nav-placement")
          .css("height", parseInt(navBody.outerHeight()) + "px")
          .css("right", "0px");
        navBody.addClass("nav-body-show");
      });
    instance.$(".nav-body")
      .on("mouseleave", function () {
        $(".main-nav-placement")
          .css("height", "")
          .css("right", "");
        $(".nav-body").removeClass("nav-body-show");
      });
  }
};
