require 'test_helper'

class ProcessLeadsControllerTest < ActionController::TestCase
  setup do
    @process_lead = process_leads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:process_leads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create process_lead" do
    assert_difference('ProcessLead.count') do
      post :create, process_lead: { email: @process_lead.email, first_name: @process_lead.first_name, last_name_f: @process_lead.last_name_f, last_name_m: @process_lead.last_name_m, phone_number: @process_lead.phone_number, process_type: @process_lead.process_type }
    end

    assert_redirected_to process_lead_path(assigns(:process_lead))
  end

  test "should show process_lead" do
    get :show, id: @process_lead
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @process_lead
    assert_response :success
  end

  test "should update process_lead" do
    patch :update, id: @process_lead, process_lead: { email: @process_lead.email, first_name: @process_lead.first_name, last_name_f: @process_lead.last_name_f, last_name_m: @process_lead.last_name_m, phone_number: @process_lead.phone_number, process_type: @process_lead.process_type }
    assert_redirected_to process_lead_path(assigns(:process_lead))
  end

  test "should destroy process_lead" do
    assert_difference('ProcessLead.count', -1) do
      delete :destroy, id: @process_lead
    end

    assert_redirected_to process_leads_path
  end
end
