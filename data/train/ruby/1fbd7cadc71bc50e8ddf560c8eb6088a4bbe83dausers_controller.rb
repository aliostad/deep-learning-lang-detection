class Api::UsersController < ApplicationController
  before_action :set_api_user, only: [:show, :update, :destroy]
  
  def index
    @api_users = User.all
    render json: @api_users
  end
  
  def show
    if @api_user.present?
      render json: @api_user
    else
      render json: {}, status: 404
    end
  end
  
  def create
    @api_user = User.new(api_user_params)
    if @api_user.save
      render json: @api_user, status: :created, location: @api_user
    else
      render json: @api_user.errors, status: :unprocessable_entity
    end
  end
  
  def update
    @api_user = User.find(params[:id])
    if @api_user.update(api_user_params)
      head :no_content
    else
      render json: @api_user.errors, status: :unprocessable_entity
    end
  end
  
  def destroy
    @api_user.destroy
    head :no_content
  end
  
  private
  
  def set_api_user
    @api_user = User.find_by_id(params[:id])
  end
  
  def api_user_params
    params[:api_user]
  end
end
