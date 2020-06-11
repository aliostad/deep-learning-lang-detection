class ProcessEngine::ProcessInstancesController < ProcessEngine::ApplicationController
  before_action :set_process_definition, only: [:index]
  before_action :set_process_instance, only: [:show, :edit, :update, :destroy]

  def index
    @process_instances = @definition.process_instances.desc.page(params[:page]).per_page(50)
  end

  def show
  end

  def edit
  end

  def update
    if @process_instance.update(process_instance_params)
      redirect_to process_instance_path(@process_instance)
    else
      render :edit
    end
  end

  def destroy
    definition_id = @process_instance.process_definition_id
    @process_instance.destroy
    redirect_to process_definition_process_instances_path(definition_id)
  end

  private

  def process_instance_params
    params.require(:process_instance).permit(:status, :state, :creator)
  end

  def set_process_definition
    @definition = ProcessEngine::ProcessDefinition.find(params[:process_definition_id])
  end

  def set_process_instance
    @process_instance = ProcessEngine::ProcessInstance.find(params[:id])
  end
end
