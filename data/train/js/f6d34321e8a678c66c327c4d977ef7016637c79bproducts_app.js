define([
  'appMarionette',
  'apps/products/list/list_controller',
  'apps/products/show/show_controller',
], function(App, ListController, ShowController ){
  'use strict';

  App.Router = Marionette.AppRouter.extend({
    appRoutes: {
      'products':                 'listProducts',
      //'products/:slug':           'showProduct',
      'espresso-machines/:slug':  'showProduct',
      'espresso-grinders/:slug':  'showProduct',
      'pizza-ovens/:slug':        'showProduct',
      'pasta-machines/:slug':     'showProduct',
      'gelato/:slug':             'showProduct',
      'citrus-juicers/:slug':     'showProduct',
      'mixers/:slug':             'showProduct',
      'panini-grills/:slug':      'showProduct',
      'juicers/:slug':            'showProduct',
      'meat-slicers/:slug':       'showProduct',
      'hot-chocolate/:slug':      'showProduct',
      'pasta-cookers/:slug':      'showProduct'
    }
  });

  var API = {

    listProducts: function(target){
      ListController.listProducts(target)
      App.execute('set:active:link', 'products')
    },

    showProduct: function(slug){
      ShowController.showProduct(slug)
      App.execute('set:active:link', '')
    }
  };

  App.on('products:list', function(target){
    API.listProducts(target)
    App.navigate('products');
  });

  App.on('product:show', function(slug, catSlug){
    API.showProduct(slug)
    App.navigate(catSlug+'/'+slug);
  });


  new App.Router({ controller: API });

});
