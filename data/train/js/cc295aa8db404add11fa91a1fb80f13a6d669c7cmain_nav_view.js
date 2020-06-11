var Backbone = require('backbone');
var MainNavCollectionView = require('./main_nav_collection_view.js');

module.exports = (function () {
  var MainNavView = Backbone.Marionette.LayoutView.extend({
    template: require('./main_nav.html'),
    headerConf: {
      title: "Applican Sample",
      showBackButton: false,
    },
    regions: {
      "navRegion": "#main-nav-region"
    },
    initialize: function(options){
      this.navCollection = options.navCollection;
    },
    onRender: function(){

      var collectionView = new MainNavCollectionView({ collection: this.navCollection });
      this.navRegion.show( collectionView );

    },
  });

  return MainNavView;
})();
