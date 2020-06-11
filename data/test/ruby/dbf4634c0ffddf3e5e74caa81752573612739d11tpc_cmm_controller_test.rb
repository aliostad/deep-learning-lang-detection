require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../../vendor/plugins/tpc/test/functional/manage/tpc_cmm_controller_test.rb'
require 'manage/tpc_cmm_controller'

# Re-raise errors caught by the controller.
class Manage::TpcCmmController; def rescue_action(e) raise e end; end

class Manage::TpcCmmControllerTest < ActionController::TestCase
  include Manage::TpcCmmControllerTestModule
    
  def setup
    @controller = Manage::TpcCmmController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    super
  end
  
  def teardown
  end
  
  # You must write UnitTest!!
  def test_default
    assert true
  end
  
end