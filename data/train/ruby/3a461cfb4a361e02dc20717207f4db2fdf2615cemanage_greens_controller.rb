class ManageGreensController < ApplicationController
  before_action :set_manage_green, only: [:show, :edit, :update, :destroy]

  # GET /manage_greens
  # GET /manage_greens.json
  def index
    @manage_greens = ManageGreen.all
  end

  # GET /manage_greens/1
  # GET /manage_greens/1.json
  def show
  end

  # GET /manage_greens/new
  def new
    @manage_green = ManageGreen.new
  end

  # GET /manage_greens/1/edit
  def edit
  end

  # POST /manage_greens
  # POST /manage_greens.json
  def create
    @manage_green = ManageGreen.new(manage_green_params)

    respond_to do |format|
      if @manage_green.save
        format.html { redirect_to @manage_green, notice: 'Manage green was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_green }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_green.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_greens/1
  # PATCH/PUT /manage_greens/1.json
  def update
    respond_to do |format|
      if @manage_green.update(manage_green_params)
        format.html { redirect_to @manage_green, notice: 'Manage green was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_green.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_greens/1
  # DELETE /manage_greens/1.json
  def destroy
    @manage_green.destroy
    respond_to do |format|
      format.html { redirect_to manage_greens_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_green
      @manage_green = ManageGreen.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_green_params
      params.require(:manage_green).permit(:title, :sub_category, :image, :created_by, :desc)
    end
end
