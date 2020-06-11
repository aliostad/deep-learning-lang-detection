require_relative '../../load_helper'
module WebTest
  module Pm
    module ProjectOutsourceManage
      class ProjectOutsourceManageSpec
        describe 'project  outsource manage page' do
          before :all do
             driver = Support::Login.login
            @page_container = WebDriver.create_page_container :pm,driver
             @pm_profiles = Helper::ReadProfiles.apps_res_zh :pm
            @project_list_page = @page_container.project_list_page
             @project_outsource_manage_page = @page_container.project_outsource_manage_page

             @project_list_page.to_this_page
             project_name = @pm_profiles['project_list']['project_name']
             @project_list_page.enter_project project_name
             @project_outsource_manage_page.to_this_page
            end

            after :all do
                    @page_container.close
            end
            it 'project_outsource_manage menu click success?' do
             project_outsource_manage_top_title=@pm_profiles['project_outsource_manage']['project_outsource_manage_top_title']
             actual = @project_outsource_manage_page.top_title
             actual.should == project_outsource_manage_top_title
            end

          end
        end
     end # ProjectOutsourceManage
  end # Pm
end #WebTest
