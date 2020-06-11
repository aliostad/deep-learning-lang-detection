class Api::V1::UsersController < ApplicationController
  # GET /api/v1/users
  # GET /api/v1/users.json
  def index
    @api_v1_users = Api::V1::User.all

    render json: @api_v1_users
  end

  # GET /api/v1/users/1
  # GET /api/v1/users/1.json
  def show
    @api_v1_user = Api::V1::User.find(params[:id])

    render json: @api_v1_user
  end

  # POST /api/v1/users
  # POST /api/v1/users.json
  def create
    @api_v1_user = Api::V1::User.new(api_v1_user_params)

    if @api_v1_user.save
      render json: @api_v1_user, status: :created, location: @api_v1_user
    else
      render json: @api_v1_user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/users/1
  # PATCH/PUT /api/v1/users/1.json
  def update
    @api_v1_user = Api::V1::User.find(params[:id])

    if @api_v1_user.update(api_v1_user_params)
      head :no_content
    else
      render json: @api_v1_user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1
  # DELETE /api/v1/users/1.json
  def destroy
    @api_v1_user = Api::V1::User.find(params[:id])
    @api_v1_user.destroy

    head :no_content
  end

  private
    
    def api_v1_user_params
      params.require(:api_v1_user).permit(:user_name, :user_email, :password)
    end
end
