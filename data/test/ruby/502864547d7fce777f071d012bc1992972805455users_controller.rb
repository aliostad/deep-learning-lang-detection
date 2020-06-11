class UsersController < ApplicationController
    before_filter :authenticate_user!
    before_filter :can_manage

    def create
        @user = User.new(user_params)
        if @user.validate?
            @user.save
            redirect_to manage_users_path, notice: "User successfully created"
        else
            redirect_to manage_users_path, notice: "Could not create user."
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(:can_manage => params[:can_manage], :can_sell => params[:can_sell], :can_report => params[:can_report])
            redirect_to manage_users_path
        else
            redirect_to manage_users_path
        end
    end


    private
    def user_params
      params.require(:user).permit(:email, :password, :can_sell, :can_manage, :can_report)
    end
end
