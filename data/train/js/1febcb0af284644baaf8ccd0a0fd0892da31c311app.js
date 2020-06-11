var app = angular.module('myApp', []);

app.factory('LogService', function() {
  var logService = {};
  logService.nivel = 0;
  logService.mensagem = "";

  logService.addLog = function(nivel,mensagem){
    logService.nivel = nivel;
    logService.mensagem = mensagem;
  }

  logService.printLog = function(){
    if(logService.nivel == 0){
      console.log(Date()+" "+logService.mensagem);
    } else if(logService.nivel == 1) {
      console.error(Date()+" "+logService.mensagem);
    }
  }

  return logService;
  
});


app.controller('LogController', ['LogService', function(logService) {

  var nivel = 0;
  var mensagem = "";

  this.imprime = function(){
    logService.addLog(this.nivel,this.mensagem);
    logService.printLog();
  }


}]);

