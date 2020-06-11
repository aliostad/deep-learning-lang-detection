// CONTROLLERS
spoke.controller = {
  def : {},
  
  define : function( controller_def ){

    var controller;
    // initialize definition
    if (!controller_def.name) throw new Error('Controller name not defined.');
    controller_def.target = controller_def.target || 'body';
    controller_def.server_events = controller_def.server_events || {};
    
    // create sammy controller
    if ( !spoke.controller[controller_def.name] ){
      controller = jQuery.sammy();
    }
      
    // set scope of controller
    controller.element_selector = controller_def.target;
    
    // define routes and events
    jQuery.each( controller_def.actions, function( name, definition){
      if( typeof( definition ) == 'function'){
        controller.bind( controller_def.name+'::'+name, definition);
      }
    });

    // define server events
    jQuery.each( controller_def.server_events, function( name, definition){
      if( typeof( definition ) == 'function'){
        controller.bind( controller_def.name+'::'+name, definition);
      }
    });
    
    // load filters
    /*
    var filters = ['before_filters','after_filters','around_filters'];
    
    jQuery.each(filters, function( index, filter_type){
      controller_def[filter_type] = controller_def[filter_type] || {};
      jQuery.each( controller_def[filter_type], function( name, definition){
        if( typeof( definition ) == 'function'){
          controller.before(definition);
        }
      });
    });
    */
    
    // load helpers
    if(controller_def.helpers){
      controller.helpers(controller_def.helpers);
    }    

/*    
    if( typeof( controller_def.not_found ) == 'function'){
          controller.notFound = controller_def.not_found;
    }
*/
    
    //initialize controller
    jQuery(function(){
      controller.run();
    });
    
    spoke.controller[controller_def.name] = controller;
    spoke.controller.def[controller_def.name] = controller_def;
  }
};