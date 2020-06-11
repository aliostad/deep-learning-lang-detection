require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../../vendor/plugins/abm/test/functional/manage/abm_album_controller_test.rb'
require 'manage/abm_album_controller'

# Re-raise errors caught by the controller.
class Manage::AbmAlbumController; def rescue_action(e) raise e end; end

class Manage::AbmAlbumControllerTest < ActionController::TestCase
  include Manage::AbmAlbumControllerTestModule
  
  def setup
    @controller = Manage::AbmAlbumController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @album1 = abm_albums(:one)
    @album2 = abm_albums(:two)
    
    setup_fixture_files
  end

  def teardown
    teardown_fixture_files
  end

  # You must write UnitTest!!
  def test_default
    assert true
  end
  
end
