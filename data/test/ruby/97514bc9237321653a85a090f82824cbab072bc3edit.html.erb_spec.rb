require 'spec_helper'

describe "process_steps/edit" do
  before(:each) do
    @process_step = assign(:process_step, stub_model(ProcessStep,
      :title => "MyString",
      :company_id => 1,
      :description => "MyText",
      :type_id => 1,
      :process_id => 1,
      :created_by => 1,
      :updated_by => 1
    ))
  end

  it "renders the edit process_step form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => process_steps_path(@process_step), :method => "post" do
      assert_select "input#process_step_title", :name => "process_step[title]"
      assert_select "input#process_step_company_id", :name => "process_step[company_id]"
      assert_select "textarea#process_step_description", :name => "process_step[description]"
      assert_select "input#process_step_type_id", :name => "process_step[type_id]"
      assert_select "input#process_step_process_id", :name => "process_step[process_id]"
      assert_select "input#process_step_created_by", :name => "process_step[created_by]"
      assert_select "input#process_step_updated_by", :name => "process_step[updated_by]"
    end
  end
end
