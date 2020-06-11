class ProcessEngine::ProcessTasksController < ProcessEngine::ApplicationController
  before_action :set_process_instance, only: [:index]
  before_action :set_process_task, only: [:finish, :show, :edit, :update, :destroy]

  def index
    @process_tasks = @process_instance.process_tasks.desc.page(params[:page]).per_page(50)
  end

  def finish
    ProcessEngine::ProcessQuery.task_complete(@process_task.id) unless @process_task.finished?
    redirect_to process_instance_process_tasks_path(@process_task.process_instance_id)
  end

  private

  def set_process_task
    @process_task = ProcessEngine::ProcessTask.find(params[:id])
  end

  def set_process_instance
    @process_instance = ProcessEngine::ProcessInstance.find(params[:process_instance_id])
  end
end
