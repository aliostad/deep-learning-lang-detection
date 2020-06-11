using MonoTouch.Foundation;
using MonoTouch.UIKit;
using System;
using System.CodeDom.Compiler;
using System.Linq;

namespace prayerapplication
{
	partial class MenuController : BaseController
	{
		public MenuController (IntPtr handle) : base (handle)
		{
		}

		public override void ViewDidLoad ()
		{					
			base.ViewDidLoad ();

			var activityController = (ActivityController)Storyboard.InstantiateViewController("ActivityController");
			var prayerRequestController = (PrayerRequestController)Storyboard.InstantiateViewController("PrayerRequestController");
			var praiseReportController = (PraiseReportController)Storyboard.InstantiateViewController("PraiseReportController");
			var groupsController = (GroupsController)Storyboard.InstantiateViewController("GroupsController");
			var friendsController = (FriendsController)Storyboard.InstantiateViewController("FriendsController");
			var settingsController = (SettingsController)Storyboard.InstantiateViewController("SettingsController");


			ActivityButton.TouchUpInside += (o, e) => {
				if (NavController.TopViewController as ActivityController == null){
					var ex = NavController.ViewControllers.OfType<ActivityController>().FirstOrDefault();
					if (ex != null)
					{
						NavController.PopToViewController(ex,true);
					} else {
					NavController.PushViewController (activityController, false);
					}
				}
				SidebarController.CloseMenu ();
			};
			PrayerRequestsButton.TouchUpInside += (o, e) => {
				if (NavController.TopViewController as PrayerRequestController == null){
					var ex = NavController.ViewControllers.OfType<PrayerRequestController>().FirstOrDefault();
					if (ex != null)
					{
						NavController.PopToViewController(ex,true);
					} else {
						NavController.PushViewController (prayerRequestController, false);
					}
				}
				SidebarController.CloseMenu ();
			};
			PraiseReportsButton.TouchUpInside += (o, e) => {
					if (NavController.TopViewController as PraiseReportController == null){
					var ex = NavController.ViewControllers.OfType<PraiseReportController>().FirstOrDefault();
						if (ex != null)
						{
							NavController.PopToViewController(ex,true);
						} else {
					NavController.PushViewController (praiseReportController, false);
						}
				}
				SidebarController.CloseMenu ();
			};
			GroupsButton.TouchUpInside += (o, e) => {
				if (NavController.TopViewController as GroupsController == null){
					var ex = NavController.ViewControllers.OfType<GroupsController>().FirstOrDefault();
					if (ex != null)
					{
						NavController.PopToViewController(ex,true);
					} else {
					NavController.PushViewController (groupsController, false);
					}
				}
				SidebarController.CloseMenu ();
			};
			FriendsButton.TouchUpInside += (o, e) => {
				if (NavController.TopViewController as FriendsController == null){
					var ex = NavController.ViewControllers.OfType<FriendsController>().FirstOrDefault();
					if (ex != null)
					{
						NavController.PopToViewController(ex,true);
					} else {
					NavController.PushViewController (friendsController, false);
					}
				}
				SidebarController.CloseMenu ();
			};
			SettingsButton.TouchUpInside += (o, e) => {
				if (NavController.TopViewController as SettingsController == null){
					var ex = NavController.ViewControllers.OfType<SettingsController>().FirstOrDefault();
					if (ex != null)
					{
						NavController.PopToViewController(ex,true);
					} else {
					NavController.PushViewController (settingsController, false);
					}
				}
				SidebarController.CloseMenu ();
			};
		}


	}
}
