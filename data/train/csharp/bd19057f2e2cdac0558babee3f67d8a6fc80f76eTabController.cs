using System;
using UIKit;

namespace SimpleChurchApp.iOS
{
	public class TabController : UITabBarController
	{
		public TabController ()
		{
			AboutController aboutController = new AboutController ();
			//UINavigationController eventsController = new UINavigationController (new EventsController ());
			ChurchEventsController eventsController = new ChurchEventsController ();
			HomeController homeController = new HomeController ();
			SermonsController sermonsController = new SermonsController ();
			SmallGroupsController smallGroupsController = new SmallGroupsController ();

			this.ViewControllers = new UIViewController[] {
				homeController,
				sermonsController,
				eventsController,
				smallGroupsController,
				aboutController
			};

			this.TabBar.BarTintColor = UIColor.DarkGray;

			this.ViewControllerSelected += TabController_ViewControllerSelected;

			EdgesForExtendedLayout = UIRectEdge.None;
		}

		void TabController_ViewControllerSelected (object sender, UITabBarSelectionEventArgs e)
		{
			this.Title = e.ViewController.Title;
		}
	}
}

