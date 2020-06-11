using UIKit;

namespace FormsPushNotificationSample.iOS
{
	public static class ViewControllerHelpers
	{
		public static UIViewController GetVisibleViewController()
		{
			var rootController = UIApplication.SharedApplication.KeyWindow.RootViewController;

			if (rootController.PresentedViewController == null)
				return rootController;

			if (rootController.PresentedViewController is UINavigationController)
			{
				return ((UINavigationController)rootController.PresentedViewController).TopViewController;
			}

			if (rootController.PresentedViewController is UITabBarController)
			{
				return ((UITabBarController)rootController.PresentedViewController).SelectedViewController;
			}

			return rootController.PresentedViewController;
		}
	}
}

