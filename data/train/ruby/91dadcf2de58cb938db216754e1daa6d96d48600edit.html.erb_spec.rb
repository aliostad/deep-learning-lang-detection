require 'spec_helper'

describe "business_processes/edit" do
  before(:each) do
    @business_process = assign(:business_process, stub_model(BusinessProcess,
      :name => "MyString",
      :company_id => 1,
      :parent_id => 1,
      :ancestry => "MyString",
      :purpose => "MyString",
      :number => "MyString",
      :owner_id => 1,
      :aims => "MyString",
      :process_class_id => 1,
      :description => "MyText"
    ))
  end

  it "renders the edit business_process form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => business_processes_path(@business_process), :method => "post" do
      assert_select "input#business_process_name", :name => "business_process[name]"
      assert_select "input#business_process_company_id", :name => "business_process[company_id]"
      assert_select "input#business_process_parent_id", :name => "business_process[parent_id]"
      assert_select "input#business_process_ancestry", :name => "business_process[ancestry]"
      assert_select "input#business_process_purpose", :name => "business_process[purpose]"
      assert_select "input#business_process_number", :name => "business_process[number]"
      assert_select "input#business_process_owner_id", :name => "business_process[owner_id]"
      assert_select "input#business_process_aims", :name => "business_process[aims]"
      assert_select "input#business_process_process_class_id", :name => "business_process[process_class_id]"
      assert_select "textarea#business_process_description", :name => "business_process[description]"
    end
  end
end
