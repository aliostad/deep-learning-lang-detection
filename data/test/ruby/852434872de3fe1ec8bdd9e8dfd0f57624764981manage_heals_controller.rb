class ManageHealsController < ApplicationController
  before_action :set_manage_heal, only: [:show, :edit, :update, :destroy]

  # GET /manage_heals
  # GET /manage_heals.json
  def index
    @manage_heals = ManageHeal.all
  end

  # GET /manage_heals/1
  # GET /manage_heals/1.json
  def show
  end

  # GET /manage_heals/new
  def new
    @manage_heal = ManageHeal.new
  end

  # GET /manage_heals/1/edit
  def edit
  end

  # POST /manage_heals
  # POST /manage_heals.json
  def create
    @manage_heal = ManageHeal.new(manage_heal_params)

    respond_to do |format|
      if @manage_heal.save
        format.html { redirect_to @manage_heal, notice: 'Manage heal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_heal }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_heal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_heals/1
  # PATCH/PUT /manage_heals/1.json
  def update
    respond_to do |format|
      if @manage_heal.update(manage_heal_params)
        format.html { redirect_to @manage_heal, notice: 'Manage heal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_heal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_heals/1
  # DELETE /manage_heals/1.json
  def destroy
    @manage_heal.destroy
    respond_to do |format|
      format.html { redirect_to manage_heals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_heal
      @manage_heal = ManageHeal.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_heal_params
      params.require(:manage_heal).permit(:title, :sub_category, :image, :created_by, :desc)
    end
end
