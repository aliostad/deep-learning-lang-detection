class ProcessStepsController < ApplicationController
  load_and_authorize_resource


  def index
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_steps = ProcessStep.find_all_by_sie_process_id(params[:sie_process_id])
  end

  def show
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_step = ProcessStep.find(params[:id])
  end

  def new
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_step = ProcessStep.new
  end

  def create
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_step = ProcessStep.new(params[:process_step])

    @process_step.sie_process_id= @sie_process.id

    if @process_step.save
      if params[:commit] == "Submit & Continue"
        flash[:success] = "Successfully created process step."
        redirect_to :action => 'new'
      else
        redirect_to [@sie_process, @process_step], :notice => "Successfully created process step."
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_step = ProcessStep.find(params[:id])
  end

  def update
    params[:process_step][:output_ids] ||= []
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_step = ProcessStep.find(params[:id])
    if @process_step.update_attributes(params[:process_step])
      redirect_to [@sie_process, @process_step], :notice  => "Successfully updated process step."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @sie_process = SieProcess.find params[:sie_process_id]
    @process_step = ProcessStep.find(params[:id])
    @process_step.destroy
    redirect_to sie_process_process_steps_url, :notice => "Successfully destroyed process step."
  end
end
