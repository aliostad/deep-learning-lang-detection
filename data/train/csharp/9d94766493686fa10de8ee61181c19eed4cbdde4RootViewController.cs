using System;
using SidebarNavigation;
using UIKit;

namespace sidebar
{
	public partial class RootViewController : UIViewController
	{
		private UIStoryboard _storyboard;


		// the sidebar controller for the app
		public SidebarController SidebarController { get; private set; }

		// the navigation controller
		public NavigationController NavController { get; private set; }

		// the storyboard
		public override UIStoryboard Storyboard
		{
			get
			{
				if (_storyboard == null)
					_storyboard = UIStoryboard.FromName("Main", null);
				return _storyboard;
			}
		}

		public RootViewController() : base(null, null)
		{

		}

		public override void ViewDidLoad()
		{
			base.ViewDidLoad();

			var introController = (IntroController)Storyboard.InstantiateViewController("IntroController");
			var menuController = (MenuController)Storyboard.InstantiateViewController("MenuController");

			// create a slideout navigation controller with the top navigation controller and the menu view controller
			NavController = new NavigationController();
			NavController.PushViewController(introController, false);
			SidebarController = new SidebarController(this, NavController, menuController);
			SidebarController.MenuWidth = 220;
			SidebarController.ReopenOnRotate = false;
			SidebarController.HasShadowing = false;
		}
	}
}

