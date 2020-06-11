require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../../vendor/plugins/msg/test/functional/manage/msg_controller_test.rb'
require 'manage/msg_controller'

# Re-raise errors caught by the controller.
class Manage::MsgController; def rescue_action(e) raise e end; end

class Manage::MsgControllerTest < ActionController::TestCase
  include Manage::MsgControllerTestModule
  
  def setup
    @controller = Manage::MsgController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # You must write UnitTest!!
  def test_default
    assert true
  end
  
end
