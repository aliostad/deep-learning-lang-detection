define(
    [
        'jquery',
        'backbone',
        'handlebars',
        
        'controller'
    
    ],
    function ( $, Backbone, Handlebars ) {
        
        /**
         *
         * @param   {Object}    options
         */
        controller.BaseController = function( options ) {
            
            this.options = options; 
            this.initialize( );    
            
        };
        
        controller.BaseController.initialize = function() { };
        
        return controller.BaseController;
    }
);