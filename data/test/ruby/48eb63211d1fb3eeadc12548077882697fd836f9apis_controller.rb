class ApisController < ApplicationController
    
    def new
        @api = Api.new
        @user = current_new_user
    end
    def create
        @api = Api.create(api_params)
        @api.user = current_new_user
        if @api.save
            flash[:success] ="The Application Was Added!"
            redirect_to user_path(@api.user)
        else
            render 'new'
        end
    end    
    def index
        @api = Api.all
    end    
    def show
        if logged_in?
            @api = fetch_api
        else
            redirect_to root_path
        end
    end  
    
    def destroy
        Api.find(params[:id]).destroy
        flash[:success] = "App deleted!"
        redirect_to user_path(current_new_user)
    end
    
    private
        def api_params
            params.require(:api).permit(:name)
        end    
    
    def fetch_api
      @api = Api.find(params[:id])
    end
end
