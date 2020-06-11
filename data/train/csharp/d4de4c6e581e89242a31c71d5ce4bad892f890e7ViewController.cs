using System;

using UIKit;

using Xamarin.SWRevealViewController;

namespace SWRevealViewControllerTest
{
	public partial class ViewController : UIViewController
	{
		protected ViewController (IntPtr handle) : base (handle) { }

		partial void viewControllerExample (Foundation.NSObject sender)
		{
			var frontViewController = Storyboard.InstantiateViewController ("MainTestViewController") as MainTestViewController;
			var rearViewController = Storyboard.InstantiateViewController ("LeftTestViewController") as LeftTestViewController;

			var revealController = new SWRevealViewController (rearViewController, frontViewController);

			frontViewController.View.AddGestureRecognizer (revealController.PanGestureRecognizer);
			frontViewController.View.AddGestureRecognizer (revealController.TapGestureRecognizer);

			PresentViewController (revealController, true, null);
		}

		partial void navigationControllerExample (Foundation.NSObject sender)
		{
			var frontViewController = new UINavigationController (Storyboard.InstantiateViewController ("MainTestTableViewController") as MainTestTableViewController);
			var rearViewController = Storyboard.InstantiateViewController ("LeftTestTableViewController") as LeftTestTableViewController;

			var revealController = new SWRevealViewController (rearViewController, frontViewController);

			frontViewController.View.AddGestureRecognizer (revealController.PanGestureRecognizer);
			frontViewController.View.AddGestureRecognizer (revealController.TapGestureRecognizer);

			PresentViewController (revealController, true, null);
		}

		partial void tableViewControllerExample (Foundation.NSObject sender)
		{
			var frontViewController = Storyboard.InstantiateViewController ("MainTestTableViewController") as MainTestTableViewController;
			var rearViewController = Storyboard.InstantiateViewController ("LeftTestTableViewController") as LeftTestTableViewController;

			var revealController = new SWRevealViewController (rearViewController, frontViewController);

			frontViewController.View.AddGestureRecognizer (revealController.PanGestureRecognizer);
			frontViewController.View.AddGestureRecognizer (revealController.TapGestureRecognizer);

			PresentViewController (revealController, true, null);
		}
	}
}