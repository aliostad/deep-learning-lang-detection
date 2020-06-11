using System;
using MonoTouch.UIKit;
using AlexTouch.PSPDFKit;

namespace PSPDFKitDemoXamarin.iOS
{
	public class KSCombinedTabBarController : UITabBarController
	{
		public KSCombinedTabBarController (PSPDFViewController controller, PSPDFDocument document) : base ()
		{
			var tocController = new PSPDFOutlineViewController (document, controller.Handle);
			tocController.Title = "TOC";

			var searchController = new PSPDFSearchViewController (document, controller);
			searchController.Title = "Search";

			var bookmarksController = new PSPDFBookmarkViewController (document);
			// PSPDFViewController implements PSPDFOutlineViewControllerDelegate as a protocol.
			bookmarksController.WeakDelegate = controller;
			bookmarksController.Title = "Bookmarks";

			this.SetViewControllers (new UIViewController[] { tocController, searchController, bookmarksController }, false);
		}
	}
}

