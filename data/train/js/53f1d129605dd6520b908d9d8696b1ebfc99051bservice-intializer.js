import Ember from 'ember';


export function initialize(container, application) {
    application.inject('controller', 'location-service', 'service:location-service');
    application.inject('component', 'location-service', 'service:location-service');

    application.inject('controller', 'google-service', 'service:google-service');
    application.inject('component', 'google-service', 'service:google-service');

    application.inject('component', 'store', 'service:store');
}

export default Ember.Application.initializer({
    name: 'service-initializer',
    after: ['cookie'],
    initialize: initialize
});

