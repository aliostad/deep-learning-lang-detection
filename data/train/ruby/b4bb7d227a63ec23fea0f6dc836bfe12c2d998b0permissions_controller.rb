class Manage::PermissionsController < Manage::ApplicationController
  def index
    @permissions = Permission.all
  end

  def new
    add_breadcrumb "Управления правами доступа", manage_permissions_path
    add_breadcrumb "Новая роль", new_manage_permission_path
    @permission = Permission.new
  end

  def create
    @permission = Permission.create(permission_params)
    respond_with :manage, @permission, :location =>  manage_permissions_path
  end

  def destroy
    Permission.find(params[:id]).destroy
    redirect_to manage_permissions_path
  end

  private
    def permission_params
      params.require(:permission).permit(:role, :user_id, :name)
    end
end
