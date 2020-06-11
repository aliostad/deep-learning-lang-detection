using UIKit;

namespace IQKeyboardManager.Xamarin
{
	public static class UIWindowExtensions
	{
		public static UIViewController GetTopMostController(this UIWindow window)
		{
			var topController = window.RootViewController;

			while (topController?.PresentedViewController != null)
				topController = topController.PresentedViewController;

			return topController;
		}

		public static UIViewController GetCurrentViewController(this UIWindow window)
		{
			var currentViewController = window.GetTopMostController();

			while (currentViewController != null && currentViewController is UINavigationController &&
				   ((UINavigationController)currentViewController).TopViewController != null)
				currentViewController = ((UINavigationController)currentViewController).TopViewController;

			return currentViewController;
		}
	}
}
