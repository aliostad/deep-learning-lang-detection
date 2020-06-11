class PermissionController < ApplicationController

    before_filter :remember_url, :except => [:add_permission, :update_permission, :edit_permission, :del_permission]

  layout 'ACIsland'

  def index
    if permission_manage?
      @permissionlist = Permission.find(:all) || []
    else
      permission_denied
    end
  end

  def add_permission
        if request.post?
        if permission_manage?
          permission = Permission.new
          permission.title = params[:title]
          permission.post = params[:post]
          permission.edit = params[:edit]
          permission.delete = params[:delete]
          permission.comment = params[:comment]
          permission.god = params[:god]
          permission.edit_css = params[:edit_css]
          permission.edit_javascript = params[:edit_javascript]
          permission.category_manage = params[:category_manage]
          permission.user_manage = params[:user_manage]
          permission.permission_manage = params[:permission_manage]
          permission.menu_manage = params[:menu_manage]
          permission.diary_manage = params[:diary_manage]
          permission.mail_manage = params[:mail_manage]
          permission.view_statistics = params[:view_statistics]
          permission.edit_page = params[:edit_page]
          permission.announce = params[:announce]
          if permission.save
            add_success('/permission')
          else
            add_fail('/permission')
          end
        else
                permission_denied
        end
        else
            redirect_to '/'
        end
  end

  def del_permission
        if request.post?
        if permission_manage?
          if permission=Permission.find(params[:id])
            permission.destroy
            destroy_success('/permission')
          else
            invalid_id('/permission')
          end
        else
          permission_denied
        end
        else
            redirect_to '/'
        end
  end

  def edit_permission
        if permission_manage?
            @target = Permission.find(params[:id])
        else
            permission_denied
        end
  end

  def update_permission
        if request.post?
        if permission.manage
          if permission = Permission.find(params[:id])
            permission.title = params[:title]
            permission.post = params[:post]
            permission.edit = params[:edit]
            permission.delete = params[:delete]
            permission.comment = params[:comment]
            permission.god = params[:god]
              permission.edit_css = params[:edit_css]
              permission.edit_javascript = params[:edit_javascript]
              permission.category_manage = params[:category_manage]
              permission.user_manage = params[:user_manage]
              permission.permission_manage = params[:permission_manage]
              permission.menu_manage = params[:menu_manage]
              permission.diary_manage = params[:diary_manage]
              permission.mail_manage = params[:mail_manage]
              permission.view_statistics = params[:view_statistics]
              permission.edit_page = params[:edit_page]
            if permission.update
              update_success('/permission')
            else
              update_fail('/permission')
            end
          else
            invalid_id('/permission')
          end
        else
          permission_denied
        end
        else
            redirect_to '/'
        end
  end

end
