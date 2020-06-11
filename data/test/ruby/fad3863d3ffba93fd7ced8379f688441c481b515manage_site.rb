# -*- encoding : utf-8 -*-
ActiveAdmin.register_page "Manage Site" do
  menu if: ->{current_admin_user.can?(:manage, :site)}, label: ->{ I18n.translate("active_admin.page.manage_site") }

  page_action :disable_site, :method => :post do
    SiteParams.disable_site!
    redirect_to manage_site_path, :notice => "Сайт выключен!"
  end

  page_action :enable_site, :method => :post do
    SiteParams.enable_site!
    redirect_to manage_site_path, :notice => "Сайт включен!"
  end

  content title: "Управление сайтом" do
    render "manage_site"
  end
end
