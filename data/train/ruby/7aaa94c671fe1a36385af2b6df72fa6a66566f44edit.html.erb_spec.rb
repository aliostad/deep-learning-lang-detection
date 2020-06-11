require 'spec_helper'

describe "business_process_process_indicator_assignments/edit" do
  before(:each) do
    @business_process_process_indicator_assignment = assign(:business_process_process_indicator_assignment, stub_model(BusinessProcessProcessIndicatorAssignment,
      :business_process_id => 1,
      :process_indicator_id => 1,
      :company_id => 1
    ))
  end

  it "renders the edit business_process_process_indicator_assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => business_process_process_indicator_assignments_path(@business_process_process_indicator_assignment), :method => "post" do
      assert_select "input#business_process_process_indicator_assignment_business_process_id", :name => "business_process_process_indicator_assignment[business_process_id]"
      assert_select "input#business_process_process_indicator_assignment_process_indicator_id", :name => "business_process_process_indicator_assignment[process_indicator_id]"
      assert_select "input#business_process_process_indicator_assignment_company_id", :name => "business_process_process_indicator_assignment[company_id]"
    end
  end
end
