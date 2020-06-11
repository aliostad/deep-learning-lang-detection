var App = App || {};
App.currentController = null;
App.controllers = {};

$(document).ready(function(){
  $("#navigation > a").each(function(i, obj){
    var controller = $(obj).attr("data-controller");
    $(obj).click(function(){
      LoadController(controller);
    });
  });
});

function LoadController(controller) {
  if( App.currentController != null )
  {
    UnloadController(App.currentController, controller);
  }

  var class = App.controllers[controller];
  App.currentController = new class();
  App.currentController.init();
}

function UnloadController(controller, next) {
  App.currentController = null;
  $("#content").html("");

  LoadController(next);
}