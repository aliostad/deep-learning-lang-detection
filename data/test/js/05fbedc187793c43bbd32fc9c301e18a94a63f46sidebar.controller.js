SidebarController = function(serviceService, stateService) {
    this._stateService = stateService;
    this._serviceService = serviceService;

    this.services = [];

    this._serviceService.on('change', this._calculateServiceStates.bind(this));
};

SidebarController.prototype = {

    toggleFavorite: function(service) {
        this._stateService.toggleFavoriteState(service);
        this._serviceService.recalculateStates();
    },

    toggleHide: function(service) {
        this._stateService.toggleHide(service);
        this._serviceService.recalculateStates();
    },

    getStateFromStorage: function(id) {
        this._stateService.getStateFromStorage(id);
    },

    _calculateServiceStates: function(services) {
        var states = services.map(function(service) {
            return angular.extend({
                id: service.id,
                name: service.name
            }, this._stateService.getStateFromStorage(service.id));
        }.bind(this));

        this.services = states;
    }

};