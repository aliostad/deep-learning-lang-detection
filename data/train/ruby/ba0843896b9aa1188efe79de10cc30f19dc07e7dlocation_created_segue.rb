class LocationCreatedSegue < UIStoryboardSegue
  # - (void) perform {

  #   UIViewController *src = (UIViewController *) self.sourceViewController;
  #   UIViewController *dst = (UIViewController *) self.destinationViewController;

  #   [UIView transitionWithView:src.navigationController.view duration:0.2
  #    options:UIViewAnimationOptionTransitionFlipFromLeft
  #    animations:^{
  #      [src.navigationController pushViewController:dst animated:NO];
  #    }
  #    completion:NULL];
  # }

  def perform
    sourceViewController.navigationController.pushViewController(destinationViewController, animated: true)

    # UIView.new(transitionWithView: sourceViewController.navigationController.view,
    #            duration: 0.2,
    #            completion: nil,
    #            animations: method(:animation).to_proc)
  end

  # private

  # def animation
  #   sourceViewController.navigationController(
  #     pushViewController: destinationViewController,
  #     animated: false
  #   )
  # end
end
