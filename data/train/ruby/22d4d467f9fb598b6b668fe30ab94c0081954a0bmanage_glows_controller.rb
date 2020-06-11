class ManageGlowsController < ApplicationController
  before_action :set_manage_glow, only: [:show, :edit, :update, :destroy]

  # GET /manage_glows
  # GET /manage_glows.json
  def index
    @manage_glows = ManageGlow.all
  end

  # GET /manage_glows/1
  # GET /manage_glows/1.json
  def show
  end

  # GET /manage_glows/new
  def new
    @manage_glow = ManageGlow.new
  end

  # GET /manage_glows/1/edit
  def edit
  end

  # POST /manage_glows
  # POST /manage_glows.json
  def create
    @manage_glow = ManageGlow.new(manage_glow_params)

    respond_to do |format|
      if @manage_glow.save
        format.html { redirect_to @manage_glow, notice: 'Manage glow was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_glow }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_glow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_glows/1
  # PATCH/PUT /manage_glows/1.json
  def update
    respond_to do |format|
      if @manage_glow.update(manage_glow_params)
        format.html { redirect_to @manage_glow, notice: 'Manage glow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_glow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_glows/1
  # DELETE /manage_glows/1.json
  def destroy
    @manage_glow.destroy
    respond_to do |format|
      format.html { redirect_to manage_glows_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_glow
      @manage_glow = ManageGlow.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_glow_params
      params.require(:manage_glow).permit(:title, :sub_category, :image, :created_by, :desc)
    end
end
