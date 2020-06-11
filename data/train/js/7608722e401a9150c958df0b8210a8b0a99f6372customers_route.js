/**
    CustomersRoute
**/
Northwind.CustomersRoute = Ember.Route.extend({   

    controller: null,

    /**
        model
    **/
    model: function () {

        var controller = this.controllerFor('customers');

        if (controller) {
            return this.get('store').findQuery('customer', { offset: controller.offset, limit: controller.limit });
        }        

    },   

    /**
        setupController
    **/
    setupController: function (controller, model) {        
        controller.set('content', model);
        controller.set('contentLoaded', true);

        this.set('controller', controller);
    },

    /**
        renderTemplate
    **/
    renderTemplate: function () {

        this.render('customers', {
            into: 'application',
            outlet: 'content'
        });

        this.render('customer-list', {
            into: 'customers',
            outlet: 'customerList'
        });

    }

});