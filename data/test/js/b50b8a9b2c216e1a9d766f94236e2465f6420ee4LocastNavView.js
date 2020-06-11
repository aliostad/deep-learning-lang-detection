// LocastNavView.js
// site navigation

define([
   
'backbone',
'underscore',
'core/LocastDispatcher',
'core/LocastView',
'config',

'text!core/nav/templates/locastNavTemplate.html'

], 

function(Backbone, _, LocastDispatcher, LocastView, config, navTemplate) { 
  
    var LocastNavItemModel = Backbone.Model.extend({
      
        select: function (silent) {
            this.collection.selectNavItem(this, silent);
        }

    }); 

    var LocastNavItemView = LocastView.extend({
   
        events: { 
            'click a': 'navItemClick',
        },

        render: function () {
            var navHtml = _.template(navTemplate, this.model.toJSON());
            this.$el.append(navHtml);

            return this;
        }, 

        navItemClick: function (e) {
            this.model.select();
        }
    
    });

     var LocastNavCollection = Backbone.Collection.extend({
        
        model: LocastNavItemModel,

        selectNavItem: function(navItem, silent) {
            if (navItem.get('active') === true) {
                return;
            }
            else { 
                this.unselectNavItems();       
                navItem.set('active', true, {silent:silent});
            }
        },

        unselectNavItems: function () {
             // set all nav items to inactive and don't trigger a change event
            this.each( function (thisNavItem) {
                thisNavItem.set('active', undefined, {silent:true});
            });
        },
 
    });

    var LocastNavView = LocastView.extend({
        
        el: '#' + config.navigation.id,

        initialize: function () { 
            this.navCollection = this.navCollection || new LocastNavCollection(_.toArray(config.navigation.items));
            this.navCollection.on('change:active', this.onNavItemSelect, this);  
            this.render();
        },

        render: function () {
            this.$el.html('');
            this.navCollection.each(this.renderNavItem, this);
        },

        renderNavItem: function (model) {
            var navItemView = new LocastNavItemView({model: model});
            this.$el.append(navItemView.render().el);
        },

        getCurrentSlug: function () {
            var activeNavModel = this.navCollection.where({active: true});
            return activeNavModel[0].get('slug');
        },

        onNavItemSelect: function (navItem) {
            this.render();
        },

        setItem: function (slug) {
            // get nav item model by slug
            var thisModel = this.navCollection.where({slug: slug});
            // select the first nav item model in result
            if (thisModel[0] !== undefined) {
                thisModel[0].select(true);
                this.render();
            }
            else {
                this.navCollection.unselectNavItems();
                this.render();
            }
        }

    });

    return LocastNavView;
});
