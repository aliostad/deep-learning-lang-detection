class Manage::ConfigsController < ManageController
  before_action :set_manage_config, only: [:show, :edit, :update, :destroy]

  # GET /manage/configs
  # GET /manage/configs.json
  def index
    @manage_configs = Manage::Config.all
  end

  # GET /manage/configs/1
  # GET /manage/configs/1.json
  def show
  end

  # GET /manage/configs/new
  def new
    @manage_config = Manage::Config.new
  end

  # GET /manage/configs/1/edit
  def edit
  end

  # POST /manage/configs
  # POST /manage/configs.json
  def create
    @manage_config = Manage::Config.new(manage_config_params)

    respond_to do |format|
      if @manage_config.save
        format.html { redirect_to @manage_config, notice: 'Config was successfully created.' }
        format.json { render :show, status: :created, location: @manage_config }
      else
        format.html { render :new }
        format.json { render json: @manage_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manage/configs/1
  # PATCH/PUT /manage/configs/1.json
  def update
    respond_to do |format|
      if @manage_config.update(manage_config_params)
        format.html { redirect_to @manage_config, notice: 'Config was successfully updated.' }
        format.json { render :show, status: :ok, location: @manage_config }
      else
        format.html { render :edit }
        format.json { render json: @manage_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage/configs/1
  # DELETE /manage/configs/1.json
  def destroy
    @manage_config.destroy
    respond_to do |format|
      format.html { redirect_to manage_configs_url, notice: 'Config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_config
      @manage_config = Manage::Config.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_config_params
      params.require(:manage_config).permit(:key, :value, :field_type)
    end
end
