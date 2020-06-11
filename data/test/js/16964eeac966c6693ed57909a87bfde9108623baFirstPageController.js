angular.module('starter.controllers')
.controller('FirstPageController', ['$scope', 'GameService', 'UtilService', 'MediaService', 'OptionService', 
    function ($scope, GameService, UtilService, MediaService, OptionService) {
    $scope.initialized = GameService.IsInitialized();

    $scope.continueTo = function(){
        var phase = GameService.GetPhase();
        if (phase == "GAME") {
            UtilService.RedirectWithoutHistory('game');
        }
        else {
            UtilService.RedirectWithoutHistory('results');
        }
    }
    
    $scope.start = function ()
    {
        //Start new game 
        //Set game state to correct values
        GameService.InitNewGame();

        //TODO add default language!!!
    }

    $scope.supported = GameService.IsLocalStorageAvailable();

    function InitializeGameSettings()
    {
        //MediaService.InitializeMute();
        OptionService.SaveLanguageState(OptionService.GetLanguage());
    }

    InitializeGameSettings();
}])