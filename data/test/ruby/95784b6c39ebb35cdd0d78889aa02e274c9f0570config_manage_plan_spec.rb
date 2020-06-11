require_relative '../../load_helper'

module WebTest
  module Pm
    module ConfigManage
      
        
        describe 'config manage plan  page' do

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
            @config_manage_plan_page = @page_container.config_manage_plan_page
            @config_manage_plan_page.to_this_page
          end

          after :all do
            @page_container.close
          end

          it 'menu page test' do
            config_manage_plan = @pm_profiles['config_manage']['config_manage_plan_title']
            actual_top_title = @config_manage_plan_page.top_title
            actual_top_title.should == config_manage_plan
          end

          it 'new add preservation config manage plan success?' do
            #given
            config_manage_plan = @pm_profiles['config_manage']['config_manage_plan_title']
            change_describe_for_add = @pm_data['config_manage']['change_describe_for_add']
            date_of_plan_for_add = @pm_data['config_manage']['date_of_plan_for_add']
            audit_person_for_add = @pm_data['config_manage']['audit_person_for_add']
            operate_type = @pm_profiles['config_manage']['preservation']
            @config_manage_plan_page.new_config_manage_plan(change_describe_for_add,date_of_plan_for_add,audit_person_for_add,operate_type)
            #when
            actual = @config_manage_plan_page.config_manage_plan_by_change_describe change_describe_for_add
            #then
            actual.should == true
          end
          
          it 'modify commit config manage plan success?' do
            #given
            config_manage_plan = @pm_profiles['config_manage']['config_manage_plan_title']
            change_describe_for_add = @pm_data['config_manage']['change_describe_for_add']
            change_describe_for_modify = @pm_data['config_manage']['change_describe_for_modify']
            date_of_plan_for_add = @pm_data['config_manage']['date_of_plan_for_add']
            audit_person_for_add = @pm_data['config_manage']['audit_person_for_add']
            operate_type = @pm_profiles['config_manage']['submit_examine_and_approve']
            @config_manage_plan_page.modify_config_manage_plan(change_describe_for_add,change_describe_for_modify)
            #when
            actual = @config_manage_plan_page.config_manage_plan_by_change_describe change_describe_for_modify
            #then
            actual.should == true
          end
          
          it 'Examination and approval config manage plan success?' do
            #given
            config_manage_plan = @pm_profiles['config_manage']['config_manage_plan_title']
            change_describe_for_modify = @pm_data['config_manage']['change_describe_for_modify']
            #when
            actual = @config_manage_plan_page.examination_and_approval_config_manage_plan(change_describe_for_modify)
            #then
            actual.should == config_manage_plan
          end
          
          it 'look config manage plan success?' do
            #given
            config_manage_plan = @pm_profiles['config_manage']['config_manage_plan_title']
            change_describe_for_modify = @pm_data['config_manage']['change_describe_for_modify']
            #when
            actual = @config_manage_plan_page.look_config_manage_plan(change_describe_for_modify)
            #then
            actual.should == config_manage_plan
          end

        end #describe
    end
  end
end

