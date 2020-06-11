class ManageAdvertisementsController < ApplicationController
  before_action :set_manage_advertisement, only: [:show, :edit, :update, :destroy]

  # GET /manage_advertisements
  # GET /manage_advertisements.json
  def index
    @manage_advertisements = ManageAdvertisement.all
  end

  # GET /manage_advertisements/1
  # GET /manage_advertisements/1.json
  def show
  end

  # GET /manage_advertisements/new
  def new
    @manage_advertisement = ManageAdvertisement.new
  end

  # GET /manage_advertisements/1/edit
  def edit
  end

  # POST /manage_advertisements
  # POST /manage_advertisements.json
  def create
    @manage_advertisement = ManageAdvertisement.new(manage_advertisement_params)

    respond_to do |format|
      if @manage_advertisement.save
        format.html { redirect_to @manage_advertisement, notice: 'Manage advertisement was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_advertisement }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_advertisements/1
  # PATCH/PUT /manage_advertisements/1.json
  def update
    respond_to do |format|
      if @manage_advertisement.update(manage_advertisement_params)
        format.html { redirect_to @manage_advertisement, notice: 'Manage advertisement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_advertisements/1
  # DELETE /manage_advertisements/1.json
  def destroy
    @manage_advertisement.destroy
    respond_to do |format|
      format.html { redirect_to manage_advertisements_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_advertisement
      @manage_advertisement = ManageAdvertisement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_advertisement_params
      params.require(:manage_advertisement).permit(:top_image, :top_url, :mid_image, :mid_url, :bottom_image, :bottom_url)
    end
end
