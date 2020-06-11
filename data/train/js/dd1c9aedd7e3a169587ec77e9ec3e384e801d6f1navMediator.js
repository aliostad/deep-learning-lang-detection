import Ember from 'ember';

var NavControlMixin = Ember.Mixin.create({
  actions: {
    processNavInit: function(processNav) {
      if (this.get('navId') === processNav.get('navId')) {
        this.set('targetObject', processNav);
        this.set('target', processNav);
      }
    }
  }
});

var NavController = Ember.Object.extend(Ember.ActionHandler, Ember.Evented, NavControlMixin);

export { NavControlMixin };

export default Ember.Object.create({
  navHash: {},
  controllersHash: {},
  componentsHash: {},
  _createNavController: function(navId) {
    var navController = this.controllersHash[navId];
    if (!navController) {
      navController = NavController.create({
        navId: navId
      });
      this.controllersHash[navId] = navController;
    }
    return navController;
  },
  registerComponent: function(component) {
    var navId = component.get('navId');
    var array = this.componentsHash[navId];
    if (!array) {
      array = [];
      this.componentsHash[navId] = array;
    }
    array.push(component);
    var processNav = this.navHash[navId];
    if (processNav) {
      component.send('processNavInit', processNav);
    }
  },
  deregisterComponent: function(component) {
    this.componentsHash[component.get('navId')].removeObject(component);
  },
  getController: function(navId) {
    var navController = this._createNavController(navId);
    var processNav = this.navHash[navId];
    if (processNav) {
      navController.send('processNavInit', processNav);
    }
    return navController;
  },
  registerNav: function(processNav) {
    var navId = processNav.get('navId');
    this.navHash[navId] = processNav;
    var navController = this._createNavController(navId);
    navController.send('processNavInit', processNav);
    var components = this.componentsHash[navId];
    if (components) {
      components.forEach((component) => {
        component.send('processNavInit', processNav);
      });
    }
    return navController;
  }
});
