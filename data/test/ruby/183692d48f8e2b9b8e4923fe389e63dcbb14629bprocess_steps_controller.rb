# -*- encoding : utf-8 -*-
class ProcessStepsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @process_step = ProcessStep.find(params[:id])
    @selection_process = @process_step.selection_process

    @feedback = Feedback.new
  end

  def create
    @selection_process = SelectionProcess.find(params[:selection_process_id])    
    if @selection_process.consolidated?
      redirect_to @selection_process, notice: "Processo já consolidado"
    else
      @process_step = ProcessStep.new(params[:process_step])

      @process_step.selection_process = @selection_process

      last_step = @selection_process.process_steps.order(:order_number).last

      unless  last_step
        @process_step.order_number = 1
      else
        @process_step.order_number = last_step.order_number + 1

        if last_step.consolidated?
        @process_step.candidates += last_step.approved_candidates
        end
      end

      @process_step.save

      redirect_to @selection_process, notice: "Etapa criada com sucesso"
    end
  end

  def edit
    @selection_process = SelectionProcess.find(params[:selection_process_id ])
    @process_step = @selection_process.process_steps.find(params[:id])
  end

  def consolidate_step
    @selection_process = SelectionProcess.find(params[:selection_process_id])
    @process_step = @selection_process.process_steps.find(params[:process_step_id])


    begin
      @process_step.consolidate_step!
        @selection_process.last_step_consolidated = Time.now
        @selection_process.save
      redirect_to @selection_process, notice: "Processo consolidado com sucesso"
    rescue Exception => e
      redirect_to [@selection_process, @process_step], notice: e.message
    end
  end

  def destroy
    @process_step = ProcessStep.find(params[:id])
    @process_step.destroy
    redirect_to selection_process_path params[:selection_process_id]
  end
end

