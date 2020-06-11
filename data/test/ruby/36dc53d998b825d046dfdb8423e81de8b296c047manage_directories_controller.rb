class ManageDirectoriesController < ApplicationController
  before_action :set_manage_directory, only: [:show, :edit, :update, :destroy]

  # GET /manage_directories
  # GET /manage_directories.json
  def index
    @manage_directories = ManageDirectory.all
  end

  # GET /manage_directories/1
  # GET /manage_directories/1.json
  def show
  end

  # GET /manage_directories/new
  def new
    @manage_directory = ManageDirectory.new
  end

  # GET /manage_directories/1/edit
  def edit
  end

  # POST /manage_directories
  # POST /manage_directories.json
  def create
    @manage_directory = ManageDirectory.new(manage_directory_params)

    respond_to do |format|
      if @manage_directory.save
        format.html { redirect_to @manage_directory, notice: 'Manage directory was successfully created.' }
        format.json { render action: 'show', status: :created, location: @manage_directory }
      else
        format.html { render action: 'new' }
        format.json { render json: @manage_directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage_directories/1
  # PATCH/PUT /manage_directories/1.json
  def update
    respond_to do |format|
      if @manage_directory.update(manage_directory_params)
        format.html { redirect_to @manage_directory, notice: 'Manage directory was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @manage_directory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_directories/1
  # DELETE /manage_directories/1.json
  def destroy
    @manage_directory.destroy
    respond_to do |format|
      format.html { redirect_to manage_directories_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_directory
      @manage_directory = ManageDirectory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_directory_params
      params.require(:manage_directory).permit(:sub_category, :country, :city, :business_name, :location, :phone_no, :email, :website, :desc)
    end
end
