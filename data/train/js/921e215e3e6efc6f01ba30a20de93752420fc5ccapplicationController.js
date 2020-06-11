define([
    "Controller",
    "scripts/js/headerController/headerController.js",
    "scripts/js/sidebarController/sidebarController.js",
    "scripts/js/footerController/footerController.js",
    "scripts/js/contentController/contentController.js",
    "text!appController/applicationController.html",
    "text!appController/applicationController.css",

], function (Controller, HeaderController, SidebarController, FooterController, ContentController, html, css) {
    return Controller.extend({


        users: null,
        _headerController: null,
        _sidebarController: null,
        _footerController: null,
        _contentController: null,

        initialize: function () {
            Controller.prototype.initialize.call(this, html, css);
            this._headerController = new HeaderController();
            this._sidebarController = new SidebarController();
            this._footerController = new FooterController();
            this._contentController = new ContentController();

        },

        render: function () {


            this.$el.find(".header_cont").html(this._headerController.$el);
            this._headerController.render();

            this.$el.find(".sidebar_cont").html(this._sidebarController.$el);
            this._sidebarController.render();

            this.$el.find(".footer_cont").html(this._footerController.$el);
            this._footerController.render();

            this.$el.find(".content-wrapper").html(this._contentController.$el);
            this._contentController.render();


        }

    });
});
