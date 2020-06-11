require File.dirname(__FILE__) + '/../test_helper'
require 'manages_controller'

# Re-raise errors caught by the controller.
class ManagesController; def rescue_action(e) raise e end; end

class ManagesControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :manages

  def setup
    @controller = ManagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'Manage.count' do
      create_manage
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Manage.count' do
      create_manage(:login => nil)
      assert assigns(:manage).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Manage.count' do
      create_manage(:password => nil)
      assert assigns(:manage).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Manage.count' do
      create_manage(:password_confirmation => nil)
      assert assigns(:manage).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Manage.count' do
      create_manage(:email => nil)
      assert assigns(:manage).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_manage(options = {})
      post :create, :manage => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
