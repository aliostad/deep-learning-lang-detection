/**
 * @ngdoc controller
 * @module app.<%= name %>
 * @name <%= name %>Controller
 * @description
 * This module <%= name %> ....
 *
 */
class <%= name %>Controller {
  constructor() {
  }

  customMethod() {
    console.log('customMethod of <%= name %>Controller');
  }
}

/**
 * @ngdoc component
 * @name <%= name %>Component
 * @type {{bindings: {breadcrumbs: string}, template: *, controller: BreadcrumbController, controllerAs: string}}
 * @scope NAMESPACE
 */
let <%= name %>Component = {
  bindings: {
  },
  template: require('addPathToTemplate'),
  controller: <%= name %>Controller,
  controllerAs: 'NAMESPACE',
}

export default <%= name %>Component;

