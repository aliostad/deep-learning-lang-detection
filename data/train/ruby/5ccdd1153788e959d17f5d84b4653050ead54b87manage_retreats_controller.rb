class ManageRetreatsController < ApplicationController
  before_action :set_manage_retreat, only: [:show, :edit, :update, :destroy]

  # GET /manage_retreats
  # GET /manage_retreats.json
  def index
    @manage_retreats = ManageRetreat.all
  end

  # GET /manage_retreats/1
  # GET /manage_retreats/1.json
  def show
  end

  # GET /manage_retreats/new
  def new
    @manage_retreat = ManageRetreat.new
  end

  # GET /manage_retreats/1/edit
  def edit
  end

  # POST /manage_retreats
  # POST /manage_retreats.json
  def create
    @manage_retreat = ManageRetreat.new(manage_retreat_params)

    respond_to do |format|
      if @manage_retreat.save
        format.html { redirect_to @manage_retreat, notice: 'Manage retreat was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_retreat }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_retreat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_retreats/1
  # PATCH/PUT /manage_retreats/1.json
  def update
    respond_to do |format|
      if @manage_retreat.update(manage_retreat_params)
        format.html { redirect_to @manage_retreat, notice: 'Manage retreat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_retreat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_retreats/1
  # DELETE /manage_retreats/1.json
  def destroy
    @manage_retreat.destroy
    respond_to do |format|
      format.html { redirect_to manage_retreats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_retreat
      @manage_retreat = ManageRetreat.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_retreat_params
      params.require(:manage_retreat).permit(:title, :sub_category, :image, :created_by, :desc)
    end
end
