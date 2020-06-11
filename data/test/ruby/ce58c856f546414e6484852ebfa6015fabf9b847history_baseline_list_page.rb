require 'webdriver/common/base_page'
require 'webdriver/support/menu_action'
require 'webdriver/support/switch_action'
require  'webdriver/support/driver_extension_action'

module WebDriver
  module Rm
    module Page
      module BaselineManage
        class HistoryBaselineListPage < Common::BasePage
         include Support::MenuAction
         include Support::SwitchAction
         def to_this_page
           @page_profiles = Helper::ReadProfiles.apps_res_zh :rm
           requirements_manage = @page_profiles['requirements_manage']
           baseline_manage = @page_profiles['baseline_manage']['baseline_manage']
           history_baseline_list = @page_profiles['baseline_manage']['history_baseline_list']
           menu_click requirements_manage
           menu_click_for_hide(baseline_manage, history_baseline_list)
         end

         def top_title
           top_title = @driver[:css=>'#content h2'].text
         end
        end#HistoryBaselineListPage
      end#BaselineManage
    end#Page
  end#Rm
end#WebDriver