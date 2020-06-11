class ManagesController < ApplicationController
  layout "layouts/blank"
  before_filter :manage_login_required
  # render new.rhtml 注册
  def new
    @manage = Manage.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @manage = Manage.new(params[:manage])
    @manage.save
    if @manage.errors.empty?
      self.current_manage = @manage
      redirect_back_or_default('/')
      flash[:notice] = "注册成功!"
    else
      flash[:nitice]="注册失败,请检查"
      render :action => 'new'
    end
  end

end
