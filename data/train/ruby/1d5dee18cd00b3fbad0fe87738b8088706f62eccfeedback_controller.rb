# -*- encoding : utf-8 -*-
class FeedbackController < ApplicationController
  before_filter :authenticate_user!

  def show
    @feedback = Feedback.where(
      candidate_id: params[:cand_id], process_step_id: params[:process_step_id]).first || Feedback.new
    @selection_process = SelectionProcess.find(params[:selection_process_id])
    @process_step = @selection_process.process_steps.find(params[:process_step_id])
    @candidate = @process_step.candidates.find(params[:cand_id])

    render partial: "process_steps/candidate_eval_form",
     locals: { feedback: @feedback, cand: @candidate,
     selection_process: @selection_process, process_step: @process_step }
  end

  def eval_candidate
    @selection_process = SelectionProcess.find(params[:selection_process_id])
    @process_step = @selection_process.process_steps.find(params[:process_step_id])
    @feedback = Feedback.new(params[:feedback])
    @candidate = Candidate.find(params[:cand_id])

    @feedback.candidate = @candidate
    @feedback.process_step = @process_step

    if @feedback.save
      redirect_to [@selection_process, @process_step],
        notice: "Candidato avaliado com sucesso"
    else
      flash[:notice] = "Problema na avaliação"
      render "process_steps/show"
    end
  end

  def update_eval_candidate
    @selection_process = SelectionProcess.find(params[:selection_process_id])
    @process_step = @selection_process.process_steps.find(params[:process_step_id])
    @candidate = Candidate.find(params[:cand_id])

    @feedback = Feedback.where(process_step_id: @process_step, candidate_id: @candidate).first

    if @feedback.update_attributes!(params[:feedback])
      redirect_to [@selection_process, @process_step],
        notice: "Feedback atualizado com sucesso"
    else
      flash[:notice] = "Problema na avaliação"
      render "process_steps/show"
    end
  end
end
