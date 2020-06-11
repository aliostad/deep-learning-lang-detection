class ProcessGroupsController < ApplicationController
  before_action :set_process_group, only: [:show, :edit, :update, :destroy]

  # GET /process_groups
  # GET /process_groups.json
  def index
    @process_groups = ProcessGroup.all
  end

  # GET /process_groups/1
  # GET /process_groups/1.json
  def show
  end

  # GET /process_groups/new
  def new
    @process_group = ProcessGroup.new
  end

  # GET /process_groups/1/edit
  def edit
  end

  # POST /process_groups
  # POST /process_groups.json
  def create
    @process_group = ProcessGroup.new(process_group_params)

    respond_to do |format|
      if @process_group.save
        format.html { redirect_to @process_group, notice: 'Process group was successfully created.' }
        format.json { render :show, status: :created, location: @process_group }
      else
        format.html { render :new }
        format.json { render json: @process_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_groups/1
  # PATCH/PUT /process_groups/1.json
  def update
    respond_to do |format|
      if @process_group.update(process_group_params)
        format.html { redirect_to @process_group, notice: 'Process group was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_group }
      else
        format.html { render :edit }
        format.json { render json: @process_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_groups/1
  # DELETE /process_groups/1.json
  def destroy
    @process_group.destroy
    respond_to do |format|
      format.html { redirect_to process_groups_url, notice: 'Process group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_group
      @process_group = ProcessGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_group_params
      params.require(:process_group).permit(:name)
    end
end
