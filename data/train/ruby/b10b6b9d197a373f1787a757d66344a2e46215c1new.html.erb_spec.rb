require 'spec_helper'

describe "pluto_process_instances/new" do
  before(:each) do
    assign(:process_instance, stub_model(Pluto::ProcessInstance,
      :pluto_process_definition_id => 1,
      :core_machine_id => 1,
      :instance => 1,
      :state => "MyString",
      :requested_state => "MyString"
    ).as_new_record)
  end

  it "renders new process_instance form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pluto_process_instances_path, :method => "post" do
      assert_select "input#process_instance_pluto_process_definition_id", :name => "process_instance[pluto_process_definition_id]"
      assert_select "input#process_instance_core_machine_id", :name => "process_instance[core_machine_id]"
      assert_select "input#process_instance_instance", :name => "process_instance[instance]"
      assert_select "input#process_instance_state", :name => "process_instance[state]"
      assert_select "input#process_instance_requested_state", :name => "process_instance[requested_state]"
    end
  end
end
