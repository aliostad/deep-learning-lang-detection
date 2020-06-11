class Admin::ManageUsersController < ApplicationController
  before_action :set_admin_manage_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login
  # GET /admin/manage_users
  # GET /admin/manage_users.json
  def index
    @admin_manage_users = Admin::ManageUser.all
  end

  # GET /admin/manage_users/1
  # GET /admin/manage_users/1.json
  def show
  end

  # GET /admin/manage_users/new
  def new
    @admin_manage_user = Admin::ManageUser.new
  end

  # GET /admin/manage_users/1/edit
  def edit
  end

  # POST /admin/manage_users
  # POST /admin/manage_users.json
  def create
    @admin_manage_user = Admin::ManageUser.new(admin_manage_user_params)

    respond_to do |format|
      if @admin_manage_user.save
        format.html { redirect_to @admin_manage_user, notice: 'Manage user was successfully created.' }
        format.json { render :show, status: :created, location: @admin_manage_user }
      else
        format.html { render :new }
        format.json { render json: @admin_manage_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/manage_users/1
  # PATCH/PUT /admin/manage_users/1.json
  def update
    respond_to do |format|
      if @admin_manage_user.update(admin_manage_user_params)
        format.html { redirect_to @admin_manage_user, notice: 'Manage user was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_manage_user }
      else
        format.html { render :edit }
        format.json { render json: @admin_manage_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/manage_users/1
  # DELETE /admin/manage_users/1.json
  def destroy
    @admin_manage_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_manage_users_url, notice: 'Manage user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_manage_user
      @admin_manage_user = Admin::ManageUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_manage_user_params
      params.require(:admin_manage_user).permit(:user_name, :password)
    end
end
