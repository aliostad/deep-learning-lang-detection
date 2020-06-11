require 'spec_helper'

describe "business_process_process_indicator_assignments/index" do
  before(:each) do
    assign(:business_process_process_indicator_assignments, [
      stub_model(BusinessProcessProcessIndicatorAssignment,
        :business_process_id => 1,
        :process_indicator_id => 2,
        :company_id => 3
      ),
      stub_model(BusinessProcessProcessIndicatorAssignment,
        :business_process_id => 1,
        :process_indicator_id => 2,
        :company_id => 3
      )
    ])
  end

  it "renders a list of business_process_process_indicator_assignments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
