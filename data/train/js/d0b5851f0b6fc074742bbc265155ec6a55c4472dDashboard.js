Ext.define('Workout.controller.Dashboard', {
  extend: 'Ext.app.Controller',
  loadController: function(button) {
    if(button.controller) {
      var controller = Workout.getApplication()
                              .getController( button.controller );
      if (!controller._initialized) controller.init();
      controller.addTabPanel(button);
    }
  },
  init: function() {

    this.control({
      "#exercicios": {
        click: this.loadController
      },
      "#rotinas" : {
        click: this.loadController
      }
    });
    
  }
});