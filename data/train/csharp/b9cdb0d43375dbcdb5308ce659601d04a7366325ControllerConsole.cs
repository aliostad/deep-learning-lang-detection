using BotvaSpider.Core;
using Savchin.Forms.Docking;

namespace BotvaSpider.Consoles
{
    public class ControllerConsole : DockContent, IControllerSource
    {
        private GameController controller;

        /// <summary>
        /// Gets the controller.
        /// </summary>
        /// <value>The controller.</value>
        public GameController Controller
        {
            get
            {
                if (controller == null && !DesignMode)
                {
                    controller = new GameController(AppCore.LogOutput);
                    controller.Login();
                }
                return controller;
            }
        }
    }
}