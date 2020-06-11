# encoding: utf-8
require 'spec_helper'

describe "selection_processes/edit" do
  login_user
  
  before(:each) do
    @selection_process = assign(:selection_process, stub_model(SelectionProcess,
      :name_process => 'Premios ACME',
      :place => 'Los Angeles, CA, USA',
      :duration => '90',
      :organizer_id => '1',
      :state => 'nuevo'
    ))
  end

  it "renders the edit selection_process form" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", selection_process_path(@selection_process), "post" do
      assert_select "input#selection_process_name_process[name=?]", "selection_process[name_process]"
      assert_select "input#selection_process_place[name=?]", "selection_process[place]"
      assert_select "input#selection_process_duration[name=?]", "selection_process[duration]"
      # assert_select "input#selection_process_state[name=?]", "selection_process[state]"
      assert_select "select#selection_process_state option[selected]", text: 'nuevo'
      assert_select "input#selection_process_organizer_id[name=?]", "selection_process[organizer_id]"
    end
  end
end