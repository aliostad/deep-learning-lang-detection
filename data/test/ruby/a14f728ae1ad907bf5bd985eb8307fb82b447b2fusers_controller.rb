#encoding:utf-8

class Manage::UsersController < Manage::ApplicationController
	
  def index
    @users = User.order(:id).page(params[:page])
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已被成功删除！"
    redirect_to manage_users_url
  end

  def update
    @user = User.find(params[:id])
    @user.admin = params[:user][:admin]
    if @user.update_attribute('admin', @user.admin)
      flash[:success]="修改成功！"
      params[:user].delete(:admin)
      redirect_to manage_users_url
    else
      flash[:error]="修改失败，请重新提交！"
      params[:user].delete(:admin)
      redirect_to manage_users_url
    end
  end

end