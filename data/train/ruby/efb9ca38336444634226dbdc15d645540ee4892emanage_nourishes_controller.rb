class ManageNourishesController < ApplicationController
  before_action :set_manage_nourish, only: [:show, :edit, :update, :destroy]

  # GET /manage_nourishes
  # GET /manage_nourishes.json
  def index
    @manage_nourishes = ManageNourish.all
  end

  # GET /manage_nourishes/1
  # GET /manage_nourishes/1.json
  def show
  end

  # GET /manage_nourishes/new
  def new
    @manage_nourish = ManageNourish.new
  end

  # GET /manage_nourishes/1/edit
  def edit
  end

  # POST /manage_nourishes
  # POST /manage_nourishes.json
  def create
    @manage_nourish = ManageNourish.new(manage_nourish_params)

    respond_to do |format|
      if @manage_nourish.save
        format.html { redirect_to @manage_nourish, notice: 'Manage nourish was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_nourish }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_nourish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_nourishes/1
  # PATCH/PUT /manage_nourishes/1.json
  def update
    respond_to do |format|
      if @manage_nourish.update(manage_nourish_params)
        format.html { redirect_to @manage_nourish, notice: 'Manage nourish was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_nourish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_nourishes/1
  # DELETE /manage_nourishes/1.json
  def destroy
    @manage_nourish.destroy
    respond_to do |format|
      format.html { redirect_to manage_nourishes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_nourish
      @manage_nourish = ManageNourish.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_nourish_params
      params.require(:manage_nourish).permit(:title, :sub_category, :image, :created_by, :website, :desc)
    end
end
