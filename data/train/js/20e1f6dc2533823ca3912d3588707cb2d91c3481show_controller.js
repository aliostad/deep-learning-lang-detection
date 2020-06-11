define([ 
  'appMarionette',
  'apps/reale/show/show_view',
], function(App, ShowReale){
  'use strict';
  return {
    showReale: function(tab) {
      $.get('/espresso-machines/reale', function(obj) {

        var showReale = new ShowReale({tpl: obj.body})

        document.title = obj.title

        showReale.on('show', function() {
          if (tab)
            showReale.triggerMethod('load:tab', tab)

          App.trigger('reviews:list', showReale.reviewsRegion)
        })

        App.mainRegion.show(showReale);
      })
    }
  }
});
