require_relative '../../load_helper'

module WebTest
  module Dm
    class DocTypeManageSpec
      describe 'doc type manage page' do
        before :all do
          @dm_profiles = Helper::ReadProfiles.apps_res_zh :dm
          @doc_login_name =@dm_profiles['doc_login_name']
          @doc_login_passwd =@dm_profiles['doc_login_passwd']
          @driver = Support::Login.login(:name => @doc_login_name, :pwd => @doc_login_passwd)
          @page_container = WebDriver.create_page_container :dm, @driver
          @doc_type_manage_page = @page_container.doc_type_manage_page
          @doc_type_manage_page.to_this_page
        end

        after :all do
          @page_container.close
        end

        it 'doc type manage page accessed?'do
          expect = @dm_profiles['doc_type_manage']['doc_type_manage']
          actual = @doc_type_manage_page.top_title
          actual.should == expect
        end

        it 'add doc type page accessed?'do
          expect = @dm_profiles['doc_type_manage']['add_doc_type']
          actual = @doc_type_manage_page.add_doc_type_title
          actual.should == expect
        end

      end #describe
    end #doctypeMange
  end #dm
end #Webtest