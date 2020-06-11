class Api::V2::PeApisController < Api::ApiController
  # to include built-in api method implementation
  include ProcessEngine::Api::Base

  # allowed methods
  include_apis :process_instance, :process_definitions, :process_instance_start, :process_tasks


  # filter for any above method to authenticate/cut cross logic
  before_action :before_action_process_instance , only: [:process_instance]


  # process_instance requires params[:process_instance_id]
  # process_instance_start requires params[:process_definition_id]


  private
  def before_action_process_instance
    render json: { status: "dummy that you need to modify here" }
  end

  # required by process_tasks typed Hash
  # check more options in process query section
  def process_task_options
    {
      user: "user_123"
    }
  end

  # required by process_instance_start typed String
  # check more options in process query section
  def process_instance_start_creator
    "user_123"
  end
end
