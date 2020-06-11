using app;
using asap.core;
using asap.ui;
using app.menu;
using Game.app;

namespace app
{
    public class AppRootController : RootController
    {
        public static GameController gameController;

        public static MenuController menuController;

        public AppRootController()
        {     
        }

        public override void OnStart()
        {
            base.OnStart();

            gameController = new GameController();
            menuController = new MenuController();

            StartController(new StartupController(), 0);
        }        
    }
}
