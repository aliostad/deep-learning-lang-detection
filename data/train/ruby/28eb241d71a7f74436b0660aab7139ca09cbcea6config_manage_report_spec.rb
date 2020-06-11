require_relative '../../load_helper'
module WebTest
  module Pm
    module ConfigManage

      describe 'config manage report  page' do

        before :all do
          @pm_profiles = Helper::ReadProfiles.apps_res_zh :pm
          @pm_data = Helper::ReadProfiles.data :pm
          @pm_login_name = @pm_profiles['pcm_login_name']
          @pm_password = @pm_profiles['password']
          @driver = Support::Login.login(:name => @pm_login_name, :pwd => @pm_password)
          @page_container = WebDriver.create_page_container :pm, @driver
          @project_list_page = @page_container.project_list_page
          @project_list_page.to_this_page
          project_name = @pm_data['project_list']['project_name']
          @project_list_page.enter_project project_name
          @config_manage_report_page = @page_container.config_manage_report_page
          @config_manage_report_page.to_this_page
        end

        after :all do
          @page_container.close
        end

        it 'menu page test' do
          #given
          config_manage_report_title = @pm_profiles['config_manage']['config_manage_report_title']
          #when
          actual_top_title = @config_manage_report_page.top_title
          #then
          actual_top_title.should == config_manage_report_title
        end
        
        it 'new add config manage report success?' do
          #given
          config_manage_report_title = @pm_profiles['config_manage']['config_manage_report_title']
          report_name = @pm_data['config_manage']['report_name_for_add']
          report_start_time = @pm_data['config_manage']['report_start_time_add']
          report_end_time = @pm_data['config_manage']['report_end_time_add']
          date_of_report = @pm_data['config_manage']['date_of_report_add']
          @config_manage_report_page.new_config_manage_report(report_name,report_start_time,report_end_time,date_of_report)
          #when
          actual = @config_manage_report_page.find_report_name_by_name(report_name)
          #then
          actual.should == true
        end
        
        it 'modify config manage report success?' do
          #given
          config_manage_report_title = @pm_profiles['config_manage']['config_manage_report_title']
          report_name_for_add = @pm_data['config_manage']['report_name_for_add']
          report_name_for_modify = @pm_data['config_manage']['repoort_name_for_modify']
          @config_manage_report_page.modify_config_manage_report(report_name_for_add,report_name_for_modify)
          #when
          actual = @config_manage_report_page.find_report_name_by_name(report_name_for_modify)
          #then
          actual.should == true
        end
        
        it 'look config manage report success?' do
          #given
          config_manage_report_title = @pm_profiles['config_manage']['config_manage_report_title']
          report_name_for_modify = @pm_data['config_manage']['repoort_name_for_modify']
          #when
          actual_look_page_title = @config_manage_report_page.look_config_manage_report(report_name_for_modify)
          #then
          actual_look_page_title.should == config_manage_report_title
        end
        
        it 'delete config manage report success?' do
          #given
          report_name_for_modify = @pm_data['config_manage']['repoort_name_for_modify']
          @config_manage_report_page.delete_config_manage_report(report_name_for_modify)
          #when
          begin
            actual = @config_manage_report_page.find_report_name_by_name(report_name_for_modify)
          rescue
            puts 'not find report name'
            actual = 'not find report name'
          end
          #then
          actual.should_not == true
        end
        
      end
    end
  end
end

