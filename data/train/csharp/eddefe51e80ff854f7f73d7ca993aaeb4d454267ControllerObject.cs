using UnityEngine;

namespace Assets.Scripts.Player
{
    /// <summary>
    /// This abstract class will be what all player conponents use for the controller to control them
    /// </summary>
    public abstract class ControllerObject : MonoBehaviour
	{
		// Reference to the player controller
		protected Controller controller;

		// Method to broadcast to the controller to all components
		protected void AssignController(Controller controller)
		{
			this.controller = controller;
		}

        #region C# Properties
        /// <summary>
        /// Property for the controller
        /// </summary>
        public Controller Controller
        {
            get { return controller; }
            set { controller = value; }
        }
        #endregion
    }
}
