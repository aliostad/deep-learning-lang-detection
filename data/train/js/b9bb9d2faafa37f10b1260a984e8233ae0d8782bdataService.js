angular.module('pubsub').factory('DataService', function($rootScope){
  var dataService = {};

  dataService._data = [];

  dataService.messages = [{
    text: 'SAMPLE MESSAGE'
  }];


  dataService.setRedditData = function(subReddit, data){
    dataService._data.length = 0
    dataService._data.push(data);

    // $rootScope.$broadcast('REDDIT_DATA_UPDATED', { data: dataService.data })

  }

  dataService.getRedditData = function(){
    return dataService._data;
  }



  dataService.addMessage = function(message){
    dataService.messages.push({text: message})
  }

  return dataService;
})