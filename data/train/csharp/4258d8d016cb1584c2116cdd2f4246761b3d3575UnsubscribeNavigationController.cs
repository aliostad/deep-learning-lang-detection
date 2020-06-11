using System;
using UIKit;

namespace ProxiChat.Ios
{
	public class UnsubscribeNavigationController : UINavigationController
	{
		public UnsubscribeNavigationController(IntPtr handle) : base(handle)
		{
		}

		public override UIViewController PopViewController(bool animated)
		{
			var viewController = base.PopViewController(animated);

			if (viewController is IUnsubscribeViewController)
			{
				(viewController as IUnsubscribeViewController).UnsubscribeFromEvents();
			}

			return viewController;
		}
	}
}

