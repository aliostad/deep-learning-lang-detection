
var x = 200;
(function(){
  angular
    .module('everycent.common')
    .factory('MessageService', MessageService);

  MessageService.$inject = ['toastr'];

  function MessageService(toastr){
    var data = {};
    var service = {
      getMessageData: getMessageData,
      setMessage: setMessage,
      setErrorMessage: setErrorMessage,
      setWarningMessage: setWarningMessage,
      clearMessage: clearMessage
    };

    return service;

    function getMessageData(){
      return data;
    }

    function setMessage(message){
      clearMessage();
      data.message = message;
      toastr.success(message);
    }

    function setErrorMessage(message){
      clearMessage();
      data.errorMessage = message;
      toastr.error(message);
    }

    function setWarningMessage(message){
      clearMessage();
      data.warningMessage = message;
      toastr.warning(message);
    }

    function clearMessage(){
      data.message = '';
      data.errorMessage = '';
      data.warningMessage = '';
    }
  }
})();
