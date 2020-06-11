using System;
using UIKit;

#if __UNIFIED__

#else
using MonoTouch.UIKit;
#endif

namespace DateTimeNumberPickerForms.iOS.SourceCode.ModalPicker
{
    internal static class ModalPickerExtensions
    {
        #region Methods

        public static void PresentUsingRootViewController(this UIViewController controller)
        {
            if (controller == null)
                throw new ArgumentNullException(nameof(controller));

            var visibleViewController = GetVisibleViewController(null);
            visibleViewController?.PresentViewController(controller, true, () => { });
        }

        private static UIViewController GetVisibleViewController(UIViewController controller)
        {
            if (controller == null)
            {
                controller = UIApplication.SharedApplication.KeyWindow.RootViewController;
            }

            if (controller?.NavigationController?.VisibleViewController != null)
            {
                return controller.NavigationController.VisibleViewController;
            }

            if (controller != null && (controller.IsViewLoaded && controller.View?.Window != null))
            {
                return controller;
            }

            if (controller != null)
            {
                foreach (var childViewController in controller.ChildViewControllers)
                {
                    var foundVisibleViewController = GetVisibleViewController(childViewController);
                    if (foundVisibleViewController == null)
                        continue;

                    return foundVisibleViewController;
                }
            }            
            return controller;
        }

        #endregion
    }
}