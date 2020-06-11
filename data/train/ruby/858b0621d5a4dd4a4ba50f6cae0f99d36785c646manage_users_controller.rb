class ManageUsersController < ApplicationController
  authorize_resource :class => false

  before_filter :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @manage_users = User.all
  end

  def show
  end

  def edit
  end

  def update

    unless @manage_user ==  current_user  
      @role = Role.find(params[:role][:id])
      @manage_user.role = @role 
    end

    if @manage_user.update_attributes(params[:user])
      redirect_to manage_users_path, t('notice.succ_update', elem: User.model_name.human)
    else
      render action: "edit" 
    end
    
  end

  def destroy
    @manage_user.destroy
    redirect_to action: "index"
  end

  private
  def find_user
    @manage_user = User.find(params[:id])
  end

end
