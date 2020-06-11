using System;
using Foundation;
using UIKit;

namespace CXS.Mpos.POS.iOS
{
	public partial class NavigationViewController : UINavigationController
	{
		public const string STORYBOARD_ID = "NavigationController";

		public ContainerViewController ContainerController { get; set; }

		public NavigationViewController () : base ("NavigationViewController", null)
		{
		}

		public NavigationViewController (IntPtr handle) : base (handle)
		{
		}

		[Export ("popViewController")]
		public void PopViewController ()
		{
			PopViewController (true);
		}

		public void PushSettingsViewController ()
		{
			SettingsViewController settingsController = (SettingsViewController)Storyboard.InstantiateViewController (SettingsViewController.STORYBOARD_ID);
			PushViewController (settingsController, true);
		}

		public void PushLandingViewController ()
		{
			LandingViewController landingController = (LandingViewController)Storyboard.InstantiateViewController (LandingViewController.STORYBOARD_ID);
			PushViewController (landingController, true);
		}

		public void PushSaleViewController ()
		{
			SaleViewController saleController = (SaleViewController)Storyboard.InstantiateViewController (SaleViewController.STORYBOARD_ID);
			PushViewController (saleController, true);
		}
		
		public void PushCustomersViewController ()
		{
			CustomersViewController customersController = (CustomersViewController)Storyboard.InstantiateViewController (CustomersViewController.STORYBOARD_ID);
			PushViewController (customersController, true);
		}

		public void PushCustomerDetailViewController (string customer) 
		{
			CustomerDetailViewController detailController = (CustomerDetailViewController)Storyboard.InstantiateViewController (CustomerDetailViewController.STORYBOARD_ID);
			detailController.Customer = customer;
			PushViewController (detailController, true);
		}

		public void PushProductDetailViewController (string product) 
		{
			ProductDetailViewController detailController = (ProductDetailViewController)Storyboard.InstantiateViewController (ProductDetailViewController.STORYBOARD_ID);
			detailController.Product = product;
			PushViewController (detailController, true);
		}
	}
}