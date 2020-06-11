class Manage::FeedbackAnswersController < Manage::BaseController
  inherit_resources
  defaults :route_prefix => 'manage', :resource_class => FeedbackAnswer

  load_and_authorize_resource :class => FeedbackAnswer
  
  respond_to :js
  
  def create
    @feedback_answer = FeedbackAnswer.new(params[:feedback_answer])
    @feedback_answer.author = current_user
    create!{ manage_feedbacks_path }
  end
  
  def update
    update!{ manage_feedbacks_path }
  end
  
  def destroy
    destroy!{ manage_feedbacks_path }
  end
end
