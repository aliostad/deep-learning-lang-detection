class Manage::SessionController < ApplicationController

  def index
    render layout: false
  end

  def create
  	#判断用户名密码是否在数据库中存在
  	if manage_admin = Manage::Admin.auth(params[:name],params[:password])
      if manage_admin.is_enabled?
        admin_login(manage_admin)
  	  redirect_to manage_index_index_path
      else
        redirect_to manage_login_url,:alert => "您的账户已被禁用"
      end
  	else
  		#密码不正确或用户名不存在
  		redirect_to manage_login_url,:alert => "不正确的用户名/密码"
  	end
  end

  def logout
    admin_logout
    redirect_to manage_login_url
  end

  def vcode
    response.headers['Cache-Control'] = "private, max-age=0, no-store, no-cache, must-revalidate"
    response.headers['Pragma'] = "no-cache"
    response.headers['content-type'] = "image/png"
    image = VerifyCode.build()
    session[:manage_vcode] = image[:code]
    render text: image[:blob]
  end
end
