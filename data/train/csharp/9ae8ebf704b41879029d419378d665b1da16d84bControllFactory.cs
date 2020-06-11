using PacManShared.Controllers;

namespace PacManShared.Initialization
{
    /// <summary>
    /// An abstract class for a controllerfactory
    /// </summary>
    abstract class ControllFactory
    {
        /// <summary>
        /// Creates a controller
        /// </summary>
        /// <returns>a new controller</returns>
        protected abstract Controller createController();

        /// <summary>
        /// Returns a new Controller
        /// </summary>
        /// <returns>a new controller</returns>
        public Controller getController()
        {
            Controller controller = createController();
            return controller;
        }
    }
}
