class SessionsController < ApplicationController

  def new
  end

  def show
    render :new
  end

  def index
    render :new
  end

  def create
    session[:target_process_url]      = params[:target_process][:url]
    session[:target_process_login]    = params[:target_process][:login]
    session[:target_process_password] = params[:target_process][:password]

    TargetProcess.configure do |config|
      config.api_url  = session[:target_process_url] + "/api/v1/"
      config.username = session[:target_process_login]
      config.password = session[:target_process_password]
    end

    redirect_to projects_path
  end
end
