require 'redmine'

require_dependency 'manage_usergroups/groups_helper_patch'

Redmine::Plugin.register :manage_usergroups do
  name 'Manage Usergroups plugin'
  author 'nmgfrank'
  description 'With this plugin, more roles can view and edit the info of user group.'
  version '0.0.1'
  url 'http://nmgfrankblog.sinaapp.com'
  author_url 'http://nmgfrankblog.sinaapp.com'
  
  menu :top_menu, :manage_usergroups, {:controller => 'manage_usergroups', :action => 'index'}, :caption => :manage_usergroups_label_group
  
end
