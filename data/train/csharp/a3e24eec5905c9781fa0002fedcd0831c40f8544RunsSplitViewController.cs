using System;
using UIKit;

namespace Categories
{
    public class RunsSplitViewController : UISplitViewController
    {
        RunsTableViewController runsTableViewController;
        UINavigationController navigationController, imagesNavigationController;

        public RunsSplitViewController(RunsTableViewController ranSessions, UINavigationController nav, UINavigationController imagesTableViewNavController)
        {
            runsTableViewController = ranSessions;
            navigationController = nav;
			imagesNavigationController = imagesTableViewNavController;

            ViewControllers = new UIViewController[] { navigationController, imagesNavigationController };

        }


    }
}
