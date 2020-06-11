using System;

namespace SnakeGame
{
	/// <summary>
	/// Represents the game as a whole.
	/// </summary>
	public class MetaController
	{
		private GameController _controller;
		/// <summary>
		/// Initializes a new instance of the <see cref="SnakeGame.MetaController"/> class.
		/// </summary>
		public MetaController()
		{
			_controller = null;
		}
		/// <summary>
		/// Swaps out the current controller for another one.
		/// </summary>
		/// <param name="controller">The controller to swap to.</param>
		public void SetController(GameController controller)
		{
			controller.Done += (object sender, StateChangeEventArgs e) =>
			{
				SetController(e.Target);
			};
			_controller = controller;
		}
	}
}

