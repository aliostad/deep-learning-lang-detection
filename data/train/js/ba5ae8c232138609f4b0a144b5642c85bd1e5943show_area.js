define([
"backbone"
, "show_area_bar"
, "show_area_panel"
], function(Backbone, showAreaBarView, showAreaPanelView) {
    
    var showAreaView = Backbone.View.extend({
        tagName:            "div",
        id:                 "show_area",

        initialize: function() {
            this.showAreaBarView      = new showAreaBarView();
            this.showAreaPanelView   = new showAreaPanelView();
            this.render();
        },

        render: function() {
            this.$el.html("");
            this.$el.append(
                this.showAreaBarView.el
                , this.showAreaPanelView.el
            );
        }
    });

    return showAreaView;
});
