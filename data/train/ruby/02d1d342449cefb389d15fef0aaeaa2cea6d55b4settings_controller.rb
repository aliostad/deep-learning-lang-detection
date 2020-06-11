class Manage::SettingsController < Manage::BaseController
  authorize_resource :class => false

  # GET /manage/settings
  def index
  end
  
  # POST /manage/settings
  def create
    respond_to do |format|
    	if Freeberry::SystemSettings.update_settings(params[:settings])
        flash[:notice] = I18n.t('flash.manage.settings.create.success')
        
        format.html { redirect_to manage_settings_path }
        format.xml { head :ok }
      else
      	flash.now[:error] = I18n.t('flash.manage.settings.create.failure')
      	
        format.html { render :action => "index" }
        format.xml { head :unprocessable_entity }
      end
    end
  end
end
