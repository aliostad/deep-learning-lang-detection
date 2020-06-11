require_relative '../../load_helper'

module WebTest
  module Sm
    module ProjectManage

      describe 'work group project manage page' do
        before :all do
          driver = Support::Login.login
          @page_container = WebDriver.create_page_container :sm,driver
          @sm_profiles = Helper::ReadProfiles.apps_res_zh :sm
          @work_group_project_manage_page = @page_container.work_group_project_manage_page
          @work_group_project_manage_page.to_this_page
        end

        after :all do
          @page_container.close
        end

        it 'work group project manage menu click success?' do
          expect_top_title = @sm_profiles['project_manage']['work_group_project_manage_top_title']
          actual_top_title = @work_group_project_manage_page.top_title
          actual_top_title.should ==  expect_top_title
        end

        it 'add project under work_group' do
          pro_id = @sm_profiles['project_manage']['work_group_pro_id']
          pro_name = @sm_profiles['project_manage']['work_group_pro_name']
          pro_pm = @sm_profiles['project_manage']['work_group_pro_pm']
          pro_sm = @sm_profiles['project_manage']['work_group_pro_sm']
          pro_ql = @sm_profiles['project_manage']['work_group_pro_ql']
          pro_pcm = @sm_profiles['project_manage']['work_group_pro_pcm']
          pro_ccb = @sm_profiles['project_manage']['work_group_pro_ccb']
          @work_group_project_manage_page.add_project_under_work_group pro_id,pro_name,pro_pm,pro_sm,pro_ql,pro_pcm,pro_ccb
          actual_flag =  @work_group_project_manage_page.find_project_by_name  pro_name
          expect_flag = true
          actual_flag.should == expect_flag
        end



      end
    end # ProjectManage
  end # Sm
end # WebTest