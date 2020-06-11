/**
 * Created with IntelliJ IDEA.
 * User: Maxime
 * Date: 22/03/13
 * Time: 10:54
 * To change this template use File | Settings | File Templates.
 */

define(['jquery', 'controllers/app', 'controllers/userController', 'controllers/gameController', 'controllers/farmerController', 'controllers/farmingController', 'controllers/tchatController', 'controllers/boardController', 'controllers/fightController'], function(jQuery, App, UserController, GameController, FarmerController, FarmingController, TchatController, BoardController, FightController) {

    jQuery(function($) {

        app = undefined;
        var userController, gameController, farmerController, farmingController, tchatController, boardController, fightController;

        //Load the App (html part)
        var initApp = function() {

                app = new App();
                socket = app.init();

                socket.sessions.ennemies = new Array();

                //Load Controllers
                userController = new UserController(app);
                gameController = new GameController(app);
                farmerController = new FarmerController();
                farmingController = new FarmingController();
                tchatController = new TchatController();
                boardController = new BoardController();
                fightController = new FightController();

                //Call init configurations
                app.center();
                app.loadRessources();

                var first = true;
                $(document).on('loadRessourcesOver', function() {
                    if(first)
                    {
                        first = false;

                        //Init all events from controllers
                        userController.initEvents();

                        //Log+ContinueLoad
                        initGame();
                    }
                });
        };

        //Load the Game (canvas part)
        var initGame = function() {
            gameController.initEvents();
            farmerController.initEvents();
            farmingController.initEvents();
            tchatController.initEvents();
            boardController.initEvents();
            fightController.initEvents();
        };

        initApp();
    });

});
