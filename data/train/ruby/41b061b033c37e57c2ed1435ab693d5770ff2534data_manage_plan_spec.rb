require_relative '../../load_helper'

module WebTest
  module Pm
    module ProjectPlan
      class DataManagePlan

        describe 'Data manage plan page ' do
          before :all do
                 driver = Support::Login.login
                 @page_container = WebDriver.create_page_container :pm,driver
                 @pm_profiles = Helper::ReadProfiles.apps_res_zh :pm
                 @project_list_page = @page_container.project_list_page
                 @data_manage_plan_page = @page_container.data_manage_plan_page
                 @project_list_page.to_this_page
                 project_name = @pm_profiles['project_list']['project_name']
                 @project_list_page.enter_project project_name
                 @data_manage_plan_page.to_this_page

          end

          after :all do
            @page_container.close
          end

          it 'data manage plan menu page test' do
            data_manage_plan_list = @pm_profiles['project_plan']['data_manage_plan_list']
            actual = @data_manage_plan_page.top_title
            actual.should == data_manage_plan_list
          end

          it 'config_manage_plan_button page test' do
            except = true
            actual = @data_manage_plan_page.config_manage_plan_page_test
            @data_manage_plan_page.to_this_page
            sleep 1
            actual.should == except
          end
          
          it 'add category test'  do
            @data_manage_plan_page.add_sub_category_link_page
          end

          it 'add new data test' do
            expect = @pm_profiles['project_plan']['add_data']
            actual =  @data_manage_plan_page.add_new_data_link_page
            actual.should == expect
          end

          it 'import data test' do
            expect = @pm_profiles['project_plan']['link_work_product']
            actual = @data_manage_plan_page.import_data_link_page
            actual.should == expect
          end

        end
      end #DataManagePlan
    end #ProjectPlan
  end #Pm
end  # WebTest