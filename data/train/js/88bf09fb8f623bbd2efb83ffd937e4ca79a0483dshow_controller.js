define(['contacts-collection', 'contact-show-views', 'contact-edit-controller'],
    function(contactsCollection, contactItemShowViews, contactEditController) {

        contactItemShowViews.contactItemShowView.on('contact:edit', function(model) {

            var id = model.get('id');

            contactEditController.editContact(id);
        });

        return {

            showContact: function(id) {

                contactItemShowViews.contactItemShowView.delegateEvents();

                var App = require('app');

                var model = contactsCollection.fetched.get(id);

                if (model) {

                    contactItemShowViews.contactItemShowView.model = model;

                    App.mainRegion.show(contactItemShowViews.contactItemShowView);

                } else {

                    App.mainRegion.show(contactItemShowViews.contactItemMissingView);
                }
            }
        };
    }
);
