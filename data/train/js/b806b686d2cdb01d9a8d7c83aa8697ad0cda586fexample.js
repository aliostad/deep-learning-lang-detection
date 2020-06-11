if (typeof window === 'undefined') {
  // If running under Node
  var ServiceLocator = require("../source/servicelocator.js");
}
// Assume that previously included in <head><script src=servicelocator.js>

var locator = new ServiceLocator.Constructor;

// Print debug information in console
locator.printLog(true);

// Create mixin for services
var mixin = {
  /**
   * Set in service object new property <_state> for further use
   * @param {*} value
   */
  setState: function (value) {
    this._state = value;
  },
  /**
   * Get <_state> property from service object
   * @return {*}
   */
  getState: function () {
    return '_state' in this ? this._state : undefined;
  },
  /**
   * Get service object name
   * @return {String}
   */
  getName: function () {
    return 'name' in this ? this.name : 'Service has no name!';
  }
};

// Set it for <ServiceLocator>

locator.setMixin(mixin);

// Create constructors for services

/** @constructor */
function ServiceOne() {
  this.name = 'ServiceOne'; // this is not required
}

/** @constructor */
function ServiceTwo() {
  this.name = 'ServiceTwo';
  this.serviceFunction = function () {
    return 'Service number two function';
  };
}
/**
 * @param {*=} data
 * @constructor
 */
function ServiceThree(data) {
  // Service without <name> property
  this.data = data;
}
/** @constructor */
function ServiceFour() {
  this.name = 'ServiceFour';
}

// Registering service objects in <ServiceLocator>

// With instantiation immediately after registration
locator.register('ServiceOne', ServiceOne, true);


// In <Service Locator> registry it's instance look like this:

//{
//  __mixins: ["id", "setState", "getState", "getName"],
//  id:       "ServiceFive",
//  getState: ▸Function,
//  prop:     ▸Array,
//  setState: ▸Function,
//}

// With lazy instantiation
locator.register('ServiceTwo', ServiceTwo, false);

// No instance but have construction function

//{
//  creator: function ServiceTwo(),
//  name: "ServiceTwo",
//  prototype: ServiceTwo
//}

// Default immediate registration
locator.register('ServiceThree', ServiceThree, true, [{mydata: "example information"}]);

locator.get('ServiceThree').data; // {mydata: "example information"}

// Create service object by yourself
var serviceFour = new ServiceFour;
// Inject perilously created service object
locator.register(serviceFour.name, serviceFour);
// or
locator.register('ServiceFour', serviceFour);

// Get instance of service
var ONE = locator.get('ServiceOne');

// Call mixin method
ONE.getName(); //"ServiceOne"

// Call mixin method
ONE.setState("launched");

// Now call mixin directly from <ServiceLocator>
locator.get('ServiceOne').getState(); // "launched"

// Service number three have mixin but have no property <name>
locator.get('ServiceThree').getName(); // → "Service has no name!"

// Get currently instantiated services
locator.getAllInstantiate(); // ["ServiceOne","ServiceThree","ServiceFour"]

// Instantiate all service objects but <ServiceTwo>
locator.instantiateAll(function (serviceName) {
  if (serviceName === 'ServiceTwo') {
    return false;
  } else {
    return true;
  }
});

// Now without exceptions
locator.instantiateAll(); // → "Instantiate: ServiceTwo"

// Get currently instantiated services
locator.getAllInstantiate(); // ["ServiceOne","ServiceTwo","ServiceThree","ServiceFour"]

// Register multiple service objects
// Current state of registry inside <Service Locator>:

//{
//  ServiceFour: ▸Object
//  ServiceOne: ▸Object
//  ServiceThree: ▸Object
//  ServiceTwo: ▸Object
//}

// Add multiple services:

locator.registerAll([
  {
    /**
     * @constructor
     * @param {*} value
     */
    creator: function (value) {
      this.prop = value;
    },
    id: 'ServiceFive',
    instantiate: false
  },
  {
    service: {
      prop: 'Some property'
    },
    id: 'ServiceSix'
  }
]);

// Newly added services:

//{
//  ServiceFive: ▸Object
//  creator:     ▸Function
//}

//{
//  ServiceSix: ▸Object
//  instance:   ▸Object
//}

// Perilously setted state
locator.get('ServiceOne').getState(); // "launched"

// Remove instance, but keep service. This remove any non-default setted data in service object.
locator.removeInstance('ServiceOne');

// <ServiceLocator> will instantiate new instance of service object
// → "Instantiate: ServiceOne"
locator.get('ServiceOne').getState(); // undefined
// But perilously saved data won't back.

// Deletes a service from <ServiceLocator> and returns it's instance
var unregisteredService = locator.unregister('ServiceFive');

//{
//  __mixins: ["id", "setState", "getState", "getName"],
//  id: "ServiceFive",
//  getState: function,
//  prop: [],
//  setState: function,
//}

// Same as above, but without mixins
var unregisteredServiceWithoutMixins = locator.unregister('ServiceFive', true);
console.dir(unregisteredServiceWithoutMixins);

// Any mentions was removed so:
locator.get('ServiceFive'); // null
// → "Service is not registered: ServiceFive"

//Delete all registered services from <ServiceLocator>, and return array of their instances
locator.unregisterAll();

//{
//  "ServiceFive":  ▸Object,
//  "ServiceFour":  ▸Object,
//  "ServiceOne":   ▸Object,
//  "ServiceSix":   ▸Object,
//  "ServiceThree": ▸Object,
//  "ServiceTwo":   ▸Object,
//}

// Same as above, but returned objects have their mixins removed
locator.unregisterAll(true);
