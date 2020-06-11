class ProcessStatesController < ApplicationController
  before_action :set_process_state, only: [:show, :edit, :update, :destroy]

  # GET /process_states
  # GET /process_states.json
  def index
    @process_states = ProcessState.all
  end

  # GET /process_states/1
  # GET /process_states/1.json
  def show
  end

  # GET /process_states/new
  def new
    @process_state = ProcessState.new
  end

  # GET /process_states/1/edit
  def edit
  end

  # POST /process_states
  # POST /process_states.json
  def create
    @process_state = ProcessState.new(process_state_params)

    respond_to do |format|
      if @process_state.save
        format.html { redirect_to @process_state, notice: 'Process state was successfully created.' }
        format.json { render action: 'show', status: :created, location: @process_state }
      else
        format.html { render action: 'new' }
        format.json { render json: @process_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_states/1
  # PATCH/PUT /process_states/1.json
  def update
    respond_to do |format|
      if @process_state.update(process_state_params)
        format.html { redirect_to @process_state, notice: 'Process state was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @process_state.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_states/1
  # DELETE /process_states/1.json
  def destroy
    @process_state.destroy
    respond_to do |format|
      format.html { redirect_to process_states_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_state
      @process_state = ProcessState.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_state_params
      params.require(:process_state).permit(:id, :process_name, :process_action, :process_state, :process_info, :process_pid, :simulate_only, :start_time, :end_time, :region)
    end
end
