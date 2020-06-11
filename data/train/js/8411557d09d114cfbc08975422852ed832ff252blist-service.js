export function initialize(container, application) {
    // Make the ember-data store available in the service
    application.inject('service:list', 'store', 'service:store');

    // Inject into all routes and controllers
    application.inject('route', 'listService', 'service:list');
    application.inject('controller', 'listService', 'service:list');
    application.inject('component', 'listService', 'service:list');
}

export default {
    name: 'list-service',
    after: 'store',
    initialize: initialize
};
