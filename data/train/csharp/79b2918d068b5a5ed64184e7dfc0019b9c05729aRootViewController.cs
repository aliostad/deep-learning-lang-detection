using System;

using UIKit;
using SidebarNavigation;

namespace FoodDiary2.iOS.Controller
{
	public  class RootViewController : UIViewController
	{
		// the sidebar controller for the app
		public SidebarController SidebarController { get; private set; }
		public UINavigationController navbarController { get; private set; }

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();


			navbarController = new UINavigationController (AppDelegate.Storyboard.InstantiateViewController ("FDMainVC"));
			navbarController.NavigationBar.Translucent = false;
			// create a slideout navigation controller with the top navigation controller and the menu view controller
			SidebarController = new SidebarController(this, 
				navbarController, 
				AppDelegate.Storyboard.InstantiateViewController("SlideBarController")
			);
			SidebarController.MenuLocation = SidebarController.MenuLocations.Left;
		}
	}
}


