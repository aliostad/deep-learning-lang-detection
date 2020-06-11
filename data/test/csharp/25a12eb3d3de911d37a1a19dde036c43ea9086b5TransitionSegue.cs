using System;
using UIKit;

namespace ContainerViews
{
    public partial class TransitionSegue : UIStoryboardSegue
    {
        public TransitionSegue (IntPtr handle) : base (handle)
        {
        }

        public override void Perform()
        {
            if (SourceViewController.ChildViewControllers.Length > 0)
            {
                SwapFromViewController(SourceViewController.ChildViewControllers[0], DestinationViewController);
            }
            else
            {
                AddInitialViewController(DestinationViewController);
            }
        }

        private void AddInitialViewController(UIViewController viewController)
        {
            //on first run no transition animation
            SourceViewController.AddChildViewController(viewController);

            viewController.View.Frame = SourceViewController.View.Bounds;

            SourceViewController.Add(viewController.View);

            viewController.DidMoveToParentViewController(SourceViewController);

            var containerViewController = SourceViewController as ITransitioningViewController;
            if(containerViewController != null)
                containerViewController.ViewChanging.TrySetResult(true);
        }

        private void SwapFromViewController(UIViewController fromViewController,
                                            UIViewController toViewController)
        {
            fromViewController.WillMoveToParentViewController(null);

            toViewController.View.Frame = SourceViewController.View.Bounds;

            SourceViewController.AddChildViewController(toViewController);

            SourceViewController.Transition(fromViewController,
                       toViewController,
                       0.3,
                       UIViewAnimationOptions.TransitionCrossDissolve,
                       () => { },
                       (bool finished) =>
                        {
                            fromViewController.RemoveFromParentViewController();
                            toViewController.DidMoveToParentViewController(SourceViewController);

                            var containerViewController = SourceViewController as ITransitioningViewController;
                            if (containerViewController != null)
                                containerViewController.ViewChanging.TrySetResult(true);
                        });
        }
    }
}