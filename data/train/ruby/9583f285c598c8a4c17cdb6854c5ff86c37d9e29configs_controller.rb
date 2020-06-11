class Manage::ConfigsController < ManageController
  before_action :set_manage_config, only: [:edit, :update]

  # GET /manage/configs
  def index
    @config_types = Manage::ConfigType.all
  end


  # GET /manage/configs/1/edit
  def edit
  end


  # PATCH/PUT /manage/configs/1
  def update
    respond_to do |format|
      if @manage_config.update(manage_config_params)
        format.html { redirect_to manage_configs_path, notice: "#{@manage_config.key}的值已更新为#{@manage_config.value}" }
      else
        format.html { render :edit }
      end
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
