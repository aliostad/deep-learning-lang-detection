class Manage::PermissionsController < Manage::ApplicationController
  def index
    @users = User.all
  end

  def new
    add_breadcrumb 'Все пользователи', manage_permissions_path
    add_breadcrumb 'Добавить право доступа', new_manage_permission_path

    @permission = Permission.new
  end

  def create
    add_breadcrumb 'Все пользователи', manage_permissions_path
    add_breadcrumb 'Добавить право доступа', new_manage_permission_path

    @permission = Permission.new(params[:permission])

    if @permission.save
      redirect_to manage_permissions_path
    else
      render :new
    end
  end

  def destroy
    Permission.find(params[:id]).destroy
    redirect_to manage_permissions_path
  end
end
