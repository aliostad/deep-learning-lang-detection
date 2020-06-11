class ActivityProcessesController < ApplicationController
  before_action :set_activity_process, only: [:show, :edit, :update, :destroy]

  # GET /activity_processes
  # GET /activity_processes.json
  def index
    @activity_processes = ActivityProcess.all
  end

  # GET /activity_processes/1
  # GET /activity_processes/1.json
  def show
    @activity_process = ActivityProcess.find(params[:id])
    @process = SelectiveProcess.find(@activity_process.SelectiveProcess_id)
    @feedback = Feedback.new
    @feedbacks = Feedback.where(["ActivityProcess_id = ? ", @activity_process.id])

  end

  # GET /activity_processes/new
  def new
    @activity_process = ActivityProcess.new
   
  end

  def new_process_defined
     @activity_process = ActivityProcess.new
     @selective_process = SelectiveProcess.find(params[:id])
  end

  # GET /activity_processes/1/edit
  def edit
  end

  # POST /activity_processes
  # POST /activity_processes.json
  def create
    @activity_process = ActivityProcess.new(activity_process_params)

    respond_to do |format|
      if @activity_process.save
        format.html { redirect_to @activity_process, notice: 'Atividade criada com sucesso.' }
        format.json { render :show, status: :created, location: @activity_process }
      else
        format.html { render :new }
        format.json { render json: @activity_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activity_processes/1
  # PATCH/PUT /activity_processes/1.json
  def update
    respond_to do |format|
      if @activity_process.update(activity_process_params)
        format.html { redirect_to @activity_process, notice: 'Atividade atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @activity_process }
      else
        format.html { render :edit }
        format.json { render json: @activity_process.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_processes/1
  # DELETE /activity_processes/1.json
  def destroy
    @activity_process.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Atividade excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_process
      @activity_process = ActivityProcess.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_process_params
      params.require(:activity_process).permit(:SelectiveProcess_id, :name_activity, :responsible_activity, :description_activity, :deadline_activity)
    end
end
