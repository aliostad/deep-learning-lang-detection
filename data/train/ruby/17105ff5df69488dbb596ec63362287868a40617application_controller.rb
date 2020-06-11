class ApplicationController < UIViewController
  def setup_action
    setup_controller = SetupController.new
    setup_controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical

    show_modal(setup_controller)
  end

  def next_question_action
    show_controller(QuestionController.new)
  end

  private
  def show_controller controller
    self.navigationController.pushViewController(controller, animated: true)
  end

  def show_modal controller
    self.navigationController.presentModalViewController(controller, animated: true)
  end

  def dismiss_modal
    self.dismissViewControllerAnimated(true, completion: nil)
  end
end
