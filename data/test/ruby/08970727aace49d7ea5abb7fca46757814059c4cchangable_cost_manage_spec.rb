require_relative '../../load_helper'

module WebTest
  module Pm
    module CostManage
      class ChangableCostManageSpec
         describe 'changable cost manage page' do

           before :all do
              driver = Support::Login.login
             @page_container = WebDriver.create_page_container :pm,driver
              @pm_profiles = Helper::ReadProfiles.apps_res_zh :pm
             @project_list_page = @page_container.project_list_page
              @changable_cost_manage_page = @page_container.changable_cost_manage_page

              @project_list_page.to_this_page
              project_name = @pm_profiles['project_list']['project_name']
              @project_list_page.enter_project project_name
              @changable_cost_manage_page.to_this_page
           end

           after :all do
              @page_container.close
           end

           it 'page and link test' do
             expect = @pm_profiles['cost_manage']['changable_cost_data_list']
             actual = @changable_cost_manage_page.top_title
             actual.should == expect
           end

         end

      end #ChangableCostManageSpec
    end #CostManage
  end # Pm
end # WebTest
