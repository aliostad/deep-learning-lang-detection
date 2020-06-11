require 'spec_helper'

describe "data_processes/edit" do
  before(:each) do
    @data_process = assign(:data_process, stub_model(DataProcess,
      :playground_id => 1,
      :name => "MyString",
      :description => "MyText",
      :created_by => "MyString",
      :updated_by => "MyString",
      :owner_id => 1,
      :scope_id => 1,
      :business_object_id => 1,
      :odq_unique_id => 1,
      :odq_object_id => 1,
      :next_run_at => "",
      :status_id => 1,
      :loaded => 1,
      :inserted => 1,
      :updated => 1,
      :deleted => 1,
      :rejected => 1,
      :duration => "9.99"
    ))
  end

  it "renders the edit data_process form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", data_process_path(@data_process), "post" do
      assert_select "input#data_process_playground_id[name=?]", "data_process[playground_id]"
      assert_select "input#data_process_name[name=?]", "data_process[name]"
      assert_select "textarea#data_process_description[name=?]", "data_process[description]"
      assert_select "input#data_process_created_by[name=?]", "data_process[created_by]"
      assert_select "input#data_process_updated_by[name=?]", "data_process[updated_by]"
      assert_select "input#data_process_owner_id[name=?]", "data_process[owner_id]"
      assert_select "input#data_process_scope_id[name=?]", "data_process[scope_id]"
      assert_select "input#data_process_business_object_id[name=?]", "data_process[business_object_id]"
      assert_select "input#data_process_odq_unique_id[name=?]", "data_process[odq_unique_id]"
      assert_select "input#data_process_odq_object_id[name=?]", "data_process[odq_object_id]"
      assert_select "input#data_process_next_run_at[name=?]", "data_process[next_run_at]"
      assert_select "input#data_process_status_id[name=?]", "data_process[status_id]"
      assert_select "input#data_process_loaded[name=?]", "data_process[loaded]"
      assert_select "input#data_process_inserted[name=?]", "data_process[inserted]"
      assert_select "input#data_process_updated[name=?]", "data_process[updated]"
      assert_select "input#data_process_deleted[name=?]", "data_process[deleted]"
      assert_select "input#data_process_rejected[name=?]", "data_process[rejected]"
      assert_select "input#data_process_duration[name=?]", "data_process[duration]"
    end
  end
end
