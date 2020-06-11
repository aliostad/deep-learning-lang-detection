using System;
using UIKit;

namespace MovieSearch.iOS
{
	public class TabBarDelegate : UITabBarControllerDelegate
	{
		public override void ViewControllerSelected(UITabBarController tabBarController, UIViewController viewController)
		{
			if (viewController.GetType() == typeof(UINavigationController))
			{
				var tmp = (UINavigationController)viewController;
				var navController = tmp.TopViewController;
				if (navController.GetType() == typeof(TopRatedMovieController))
				{
					TopRatedMovieController controller = (TopRatedMovieController)navController;
					controller.setReload(true);
				}
			}
		}
	}
}
