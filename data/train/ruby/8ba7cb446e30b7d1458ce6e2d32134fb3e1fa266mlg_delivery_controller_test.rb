require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../../vendor/plugins/mlg/test/functional/manage/mlg_delivery_controller_test.rb'
require 'manage/mlg_delivery_controller'

# Re-raise errors caught by the controller.
class Manage::MlgDeliveryController; def rescue_action(e) raise e end; end

class Manage::MlgDeliveryControllerTest < ActionController::TestCase
  include Manage::MlgDeliveryControllerTestModule
  
  def setup
    @controller = Manage::MlgDeliveryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # You must write UnitTest!!
  def test_default
    assert true
  end
  
end
