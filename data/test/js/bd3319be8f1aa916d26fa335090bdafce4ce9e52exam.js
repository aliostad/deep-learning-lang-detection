frmServices.factory('examSharedService', function($rootScope) {
  var sharedService = {};

  sharedService.settings = {};
  sharedService.questions = [];
  sharedService.userAnswers = [];
  sharedService.correctAnswers = 0;
  sharedService.wrongAnswers = 0;
  sharedService.skipQuestions = 0;
  sharedService.flaggedQuestions = 0;

  sharedService.resetData = function() {
    sharedService.userAnswers = [];
    sharedService.correctAnswers = 0;
    sharedService.wrongAnswers = 0;
    sharedService.skipQuestions = 0;    
    sharedService.flaggedQuestions = 0;
  }


  return sharedService;
});
