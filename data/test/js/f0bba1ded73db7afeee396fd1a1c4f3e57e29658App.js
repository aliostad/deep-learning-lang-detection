
/*------------------------------------------------------------------------------

    Application

------------------------------------------------------------------------------*/

'use strict';

// Import Controller
import Controller from './Controller.js';

/**
 *  Application
 *  Extended Controller
 */
var App = Controller.extend({

    /**
     *  Constructor
     *  @constructor
     */
    constructor () {

        this.controllers = {};

        this.mainController = {
            name:   null,
            view:   null
        };

        Controller.apply(this, arguments);

    },

    /**
     *  Add Controller
     *  Add controller blueprint.
     *
     *  @param  {string}    name        Controller name
     *  @param  {Object}    controller  Controller blueprint
     *  @return {Object}    controller  Controller blueprint
     */
    addController (name, controller) {

        return this.controllers[name] = controller;

    },

    /**
     *  Initialize Controller
     *  Initialize controller from existing controller blueprints.
     *
     *  @param  {string}    name        Controller name
     *  @param  {Object}    args        Arguments
     *  @return {Object}    controller  Controller instance
     */
    initController (name, args) {

        return this.controllers[name] && (this.addSubview(new this.controllers[name](args)));

    },

    /**
     *  Set Up Main Controller
     *  Set up main controller, run controller method with given data and render it to given region.
     *  If controller is already initialized, just run controller method with given data.
     *
     *  @param  {string}    region          Region name
     *  @param  {string}    controller      Controller name
     *  @param  {string}    method          Controller method name
     *  @param  {Object}    data            JSON Object
     *  @return {Object}    controller view Initialized controller view instance
     */
    setupMainController (region, controller, method, data) {

        if (this.mainController.name === controller) {

            this.mainController.view[method] && (this.mainController.view[method](data));

        } else {

            this.mainController.view && (this.mainController.view.close());

            this.mainController = {
                name:   controller,
                view:   this.initController(controller, {method: method, data: data})
            };

            this.renderTo(region, [this.mainController.view.el]);

        }

        return this.mainController.view;

    },

    /**
     *  Destroy Main Controller
     *  Destroy main controller.
     *
     *  @return {Object}    this    Instance of this controller
     */
    destroyMainController () {

        this.mainController.view && (this.mainController.view.close());

        this.mainController = {
            name:   null,
            view:   null
        };

        return this;

    },

    /**
     *  Remove Controller
     *  Remove controller blueprint.
     *
     *  @param  {string}    name                Controller name
     *  @return {mixed}     undefined or true   Returns true if controller blueprint is succesfully removed
     */
    removeController (name) {

        return this.controllers[name] && (delete this.controllers[name]);

    }

});

// Export App
export default App;
