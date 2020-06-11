var indexController = {};


indexController.home = function () {
    $('#start-experience').on('click', indexController.startExperience);

    fullScreenController.listen(indexController.listenFullscreenChanges);
};


indexController.startExperience = function () {
    pageController.display('home');
    fullScreenController.enter('game-interface');
};


indexController.listenFullscreenChanges = function () {
    $('#game-interface').toggleClass('active');

    if (!fullScreenController.is()) {
        indexController.reset();
        socketInterface.send('disconnect');
    }
};


indexController.reset = function () {
    gameCellsPageController.reset();
    gameWaitingPageController.reset();
    gameFightPageController.reset();
    notificationController.reset();

    gameHomePageController.resetListeners();
    gameCharactersPageController.resetListeners();

    loadingController.hide();
};
