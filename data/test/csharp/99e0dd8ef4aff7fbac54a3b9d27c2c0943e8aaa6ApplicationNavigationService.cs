using System;
using HubBrowser.Core.Services;
using UIKit;

namespace HubBrowser.iOS.Services
{
    public class ApplicationNavigationService : IApplicationNavigationService
    {
        private readonly UINavigationController navigationController;

        public ApplicationNavigationService(UINavigationController navigationController)
        {
            this.navigationController = navigationController;
        }

        private UIViewController InstantiateViewController<T>()
        {
            return navigationController.Storyboard.InstantiateViewController(typeof (T).Name);
        }

        public void ToRepositoryList()
        {
            var controller = InstantiateViewController<RepositoryListController>();

            navigationController.PushViewController(controller, true);
        }
    }
}