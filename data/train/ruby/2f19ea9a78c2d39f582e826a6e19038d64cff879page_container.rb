require 'webdriver/common/page_container'

module WebDriver
  module Sm
    class PageContainer < Common::PageContainer
      
      def department_manage_page
        Page::StaffManage::DepartmentManagePage.new @driver
      end

      def work_group_manage_page
        Page::StaffManage::WorkGroupManagePage.new @driver
      end

      def position_manage_page
        Page::StaffManage::PositionManagePage.new @driver
      end

      def department_project_manage_page
        Page::ProjectManage::DepartmentProjectManagePage.new @driver
      end

      def work_group_project_manage_page
        Page::ProjectManage::WorkGroupProjectManagePage.new @driver
      end

      def role_setting_page
        Page::SystemSettings::RoleSettingPage.new @driver
      end

      def enum_data_page
        Page::SystemSettings::EnumDataPage.new @driver
      end

      def news_setting_page
        Page::SystemSettings::NewsSettingPage.new @driver
      end

      def cas_server_setting_page
        Page::SystemSettings::CasServerSettingPage.new @driver
      end

      def monitoring_parameters_setting_page
        Page::SystemSettings::MonitoringParametersSettingPage.new @driver
      end

      def system_outsource_settings_page
        Page::SystemOutsourceSettings::SystemOutsourceSettingsPage.new @driver
      end

      def configuration_database_logger_page
        Page::SystemLogger::ConfigurationDatabaseLoggerPage.new @driver
      end

      def permission_change_logger_page
        Page::SystemLogger::PermissionChangeLoggerPage.new @driver
      end

      def login_logger_page
        Page::SystemLogger::LoginLoggerPage.new @driver
      end

      def other_logger_page
        Page::SystemLogger::OtherLoggerPage.new @driver
      end
      
    end # PageContainer
  end # Sm
end # WebDriver