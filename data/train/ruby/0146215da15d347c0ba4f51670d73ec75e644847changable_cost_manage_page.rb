require 'webdriver/common/base_page'
require 'webdriver/support/menu_action'
require 'webdriver/support/switch_action.rb'
require 'webdriver/support/component.rb'

module WebDriver
  module Pm
    module Page
      module CostManage
        class ChangableCostManagePage < Common::BasePage
           include Support::MenuAction
           include Support::SwitchAction
           include Support::Component

          def top_title
            @driver[:css => '#content h2'].text
          end

          def to_this_page
            @pm_profiles = Helper::ReadProfiles.apps_res_zh :pm
            cost_manage = @pm_profiles['cost_manage']['cost_manage']
            changable_cost_manage = @pm_profiles['cost_manage']['changable_cost_manage']
            menu_click_for_hide cost_manage,changable_cost_manage
          end

           def yellow_button_test
             yellow_button.click
           end

          def yellow_button
            @driver[:class=>'button']
          end




        end#ChangableCostManagePage
      end#CostManage
    end #page
  end  #Pm

end #webdriver

