class SessionsController < ApplicationController
  skip_user_authentication only: [:new, :create]

  def new
  end

  def create
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "controller == session controller"
    puts "params params[:email] == "
    puts "params params[:email] == #{params[:user][:email]}"
    user = Autho::Authentication.new(User, params[:user][:email], params[:user][:password]).user
    puts "searching user == "
    puts "searching user == #{user.to_json}"
    if user
      
      user_session.user = user
      redirect_to root_path, notice: t(:"sessions.successfully_signed_in")
    else
      redirect_to :back, error: t(:"sessions.bad_credentials")
    end
  end
end

