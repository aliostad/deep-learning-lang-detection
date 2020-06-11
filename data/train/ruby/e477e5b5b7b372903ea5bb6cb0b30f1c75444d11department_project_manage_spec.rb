require_relative '../../load_helper'

module WebTest
  module Sm
    module ProjectManage
      
      describe 'department project manage page' do
        before :all do
          driver = Support::Login.login
          @page_container = WebDriver.create_page_container :sm,driver
          @sm_profiles = Helper::ReadProfiles.apps_res_zh :sm
          @department_project_manage_page = @page_container.department_project_manage_page
          @department_project_manage_page.to_this_page
        end
      
        after :all do
          @page_container.close
        end
        
        it 'department project manage menu click success?' do
          expect_top_title = @sm_profiles['project_manage']['department_project_manage_top_title']
          actual_top_title = @department_project_manage_page.top_title
          actual_top_title.should ==  expect_top_title
        end

        it 'add new project test success ?' do
          id=@sm_profiles['project_manage']['project_id']
          name = @sm_profiles['project_manage']['project_name']
          pm = @sm_profiles['project_manage']['pm']
          sm = @sm_profiles['project_manage']['sm']
          ql = @sm_profiles['project_manage']['ql']
          pcm = @sm_profiles['project_manage']['pcm']
          ccb = @sm_profiles['project_manage']['ccb']
          @department_project_manage_page.add_project_funtion  id,name,pm,sm,ql,pcm,ccb
          actual_project_name = @department_project_manage_page.search_project id
          actual_project_name.should == name
        end

      end
    end # ProjectManage
  end # Sm
end # WebTest