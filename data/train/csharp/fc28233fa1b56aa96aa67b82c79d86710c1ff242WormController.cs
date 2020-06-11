using UnityEngine;

namespace Worm
{
	public class WormController : MonoBehaviour
	{
		public InputController inputController;
		public MovementController movementController;
		public SegmentController segmentController;

		void Update () 
		{
			if (Time.time < 0.8f) {return;}

			inputController.Update_UserInput ();
			segmentController.Update_SpeedPenalty (inputController.InputSpeed);
			movementController.Update_Movement (inputController.input_Horizontal, inputController.InputSpeed);
			segmentController.Update_HeadPos ();
		}
	}
}