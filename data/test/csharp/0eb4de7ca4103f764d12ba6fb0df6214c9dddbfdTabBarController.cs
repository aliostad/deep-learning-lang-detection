using System;

using UIKit;

namespace iostest.iOS
{
	public partial class TabBarController : UITabBarController
	{
		UINavigationController GreenNavController, RedNavController, BlueNavController;

		public TabBarController(){
			InitNavControllers();

			ViewControllers = new UIViewController[] {
				GreenNavController,
				RedNavController,
				BlueNavController
			};
		}

		void InitNavControllers(){
			var greenVC = new GreenViewController();
			GreenNavController = new UINavigationController (greenVC);
			GreenNavController.Title = "Green";

			var redVC = new RedViewController ();
			RedNavController = new UINavigationController (redVC);
			RedNavController.Title = "Red";

			var blueVC = new BlueViewController ();
			BlueNavController = new UINavigationController (blueVC);
			BlueNavController.Title = "Blue";
		}
	}
}


