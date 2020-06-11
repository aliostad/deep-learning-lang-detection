class ExtendPermission < ActiveRecord::Migration
  def self.up
    add_column :permissions, :edit_css, :boolean
    add_column :permissions, :edit_javascript, :boolean
    add_column :permissions, :category_manage, :boolean
    add_column :permissions, :user_manage, :boolean
    add_column :permissions, :permission_manage, :boolean
    add_column :permissions, :menu_manage, :boolean
    add_column :permissions, :diary_manage, :boolean
    add_column :permissions, :mail_manage, :boolean
    add_column :permissions, :view_statistics, :boolean
    add_column :permissions, :edit_page, :boolean
  end

  def self.down
    remove_column :permissions, :edit_css
    remove_column :permissions, :edit_javascript
    remove_column :permissions, :category_manage
    remove_column :permissions, :user_manage
    remove_column :permissions, :permission_manage
    remove_column :permissions, :menu_manage
    remove_column :permissions, :diary_manage
    remove_column :permissions, :mail_manage
    remove_column :permissions, :view_statistics
    remove_column :permissions, :edit_page
  end
end
