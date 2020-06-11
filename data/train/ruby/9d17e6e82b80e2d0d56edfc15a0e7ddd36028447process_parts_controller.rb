class ProcessPartsController < ApplicationController
  before_action :set_process_part, only: [:show, :edit, :update, :destroy]

  # GET /process_parts
  # GET /process_parts.json
  def index
    @process_parts = ProcessPart.all
  end

  # GET /process_parts/1
  # GET /process_parts/1.json
  def show
  end

  # GET /process_parts/new
  def new
    @process_part = ProcessPart.new
    # authorize(@process_part)
  end

  # GET /process_parts/1/edit
  def edit
  end

  # POST /process_parts
  # POST /process_parts.json
  def create
    @process_part = ProcessPart.new(process_part_params)
    # authorize(@process_part)
    respond_to do |format|
      if @process_part.save
        format.html { redirect_to @process_part, notice: 'Process part was successfully created.' }
        format.json { render :show, status: :created, location: @process_part }
      else
        format.html { render :new }
        format.json { render json: @process_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /process_parts/1
  # PATCH/PUT /process_parts/1.json
  def update
    respond_to do |format|
      if @process_part.update(process_part_params)
        format.html { redirect_to @process_part, notice: 'Process part was successfully updated.' }
        format.json { render :show, status: :ok, location: @process_part }
      else
        format.html { render :edit }
        format.json { render json: @process_part.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /process_parts/1
  # DELETE /process_parts/1.json
  def destroy
    @process_part.destroy
    respond_to do |format|
      format.html { redirect_to process_parts_url, notice: 'Process part was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_process_part
      @process_part = ProcessPart.find(params[:id])
      # authorize(@process_part)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def process_part_params
      params.require(:process_part).permit(:quantity, :part_id, :process_entity_id, :unit)
    end
end
