require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../../vendor/plugins/mlg/test/functional/manage/mlg_controller_test.rb'
require 'manage/mlg_controller'

# Re-raise errors caught by the controller.
class Manage::MlgController; def rescue_action(e) raise e end; end

class Manage::MlgControllerTest < ActionController::TestCase
  include Manage::MlgControllerTestModule
  
  def setup
    @controller = Manage::MlgController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # You must write UnitTest!!
  def test_default
    assert true
  end
  
end
