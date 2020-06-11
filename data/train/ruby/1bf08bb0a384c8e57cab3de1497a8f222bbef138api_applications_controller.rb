class ApiApplicationsController < ApplicationController
	before_action :singed_in_api_user, only: [:show, :new, :create] 
	
	def show
		@api_app = ApiApplication.find(params[:id])
		@app_url = AppUrl.new
	end
	
	def new
		@api_app = current_api_user.api_applications.build
	end

	def create
		@api_app = current_api_user.api_applications.build(api_app_params)
		if @api_app.save
			flash[:success] = 'Application created successfully!'
			redirect_to @api_app.api_user
		else
			flash[:fail] = 'Failed to create application!'
			render 'new'
		end
	end
	
	def update
		@api_app = ApiApplication.find(params[:id])
		if @api_app.update_attributes api_app_params
			flash[:success] = 'Application saved'
		else
			flash[:fail] = 'Could not save application.'
		end
		redirect_to @api_app
	end

	private
		def api_app_params
			params.require(:api_application).permit(:name, :description)
		end
        
        def admin_api_user
            redirect_to(root_url) unless current_api_user.admin?
        end
end
