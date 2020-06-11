var MessageControler = (function(id){

  //VARIABLES DE ACCESO PRIVADO
  var idDiv = id;
  var message = "";
  var messageClases = ["alert-success","alert-info","alert-warning","alert-danger"];

  var checkId = function(){
    if(idDiv === "" || idDiv == null ){
      console.log("Developer, you must to load the id for Message box");  
      return false;
    }else{
      console.log("Great, Message box id exist!"); 
      return true; 
    }
  }

  var printSucessMessage = function(message){
    printMessage(messageClases[0],message);
  }

  var printInfoMessage = function(message){
    printMessage(messageClases[1],message);
  }

  var printWarningMessage = function(message){
    printMessage(messageClases[2],message);
  }

  var printDangerMessage = function(message){
    printMessage(messageClases[3],message);
  }

  var printMessage = function(type,message){
    if(checkId()){
      removeClasses();
      addClass(type);
      addMessage(message);
    }
  }

  var removeClasses = function(){
    $.each(messageClases, function( index, value ) {
      $(idDiv).removeClass(value);
    });
  }

  var addClass = function(choosenClass){
    $(idDiv).addClass(choosenClass);
  }

  var addMessage = function(message){
    $(idDiv).text(message);
  }

  // ACCESIBLE METHODS
  return {
    printSucessMessage : function(message){
     return printSucessMessage(message);
    },
    printInfoMessage : function(message){
     return printInfoMessage(message);
    },
    printWarningMessage : function(message){
     return printWarningMessage(message);
    },
    printDangerMessage : function(message){
     return printDangerMessage(message);
    },
  }

});