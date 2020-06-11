#encoding:utf-8
module Manage
  class SessionsController < Manage::ApplicationController
    skip_authorize_resource
    skip_before_filter :check_login
    layout :false

    def new

    end

    def create
      destroy_manage_session
      login = params[:login]
      password = params[:password]
      system_user = Admin.where({:login => login}).first
      if system_user and system_user.authenticate(password)
        create_manage_session system_user
        redirect_to '/manage/subjects'
      else
        flash[:error] = Tips::LOGIN_ERROR
        redirect_to '/manage/login'
      end
    end

    def logout
      destroy_manage_session
      redirect_to '/manage/login'
    end
  end
end