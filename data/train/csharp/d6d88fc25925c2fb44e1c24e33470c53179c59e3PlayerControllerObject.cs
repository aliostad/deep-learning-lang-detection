using UnityEngine;
using System.Collections;

#region ERIC
/*
 * This abstract class will be what all player conponents use for the controller to control them
 */
namespace Assets.Scripts.Player
{
	public abstract class PlayerControllerObject : MonoBehaviour
	{
		//reference to the player controller
		protected PlayerController _controller;

		//abstract methods children need to implement
		public abstract void Run();
		public abstract void FixedRun();

		//setting up events
		void OnEnable()
		{
			PlayerController.AssignController += AssignController;
		}

		void OnDisable()
		{
			PlayerController.AssignController -= AssignController;
		}

		//getter for the controller
		public PlayerController Controller
		{
			get { return this._controller; }
		}

		//method to broadcast to the controller to all components
		protected void AssignController(PlayerController _controller)
		{
			this._controller = _controller;
		}
	}
}
#endregion