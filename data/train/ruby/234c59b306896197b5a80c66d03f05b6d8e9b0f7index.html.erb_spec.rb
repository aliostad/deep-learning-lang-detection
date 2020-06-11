require 'spec_helper'

describe "manage/friends/index" do
  before(:each) do
    assign(:manage_friends, [
      stub_model(Manage::Friend,
        :from_user_id => 1,
        :to_user_id => 2
      ),
      stub_model(Manage::Friend,
        :from_user_id => 1,
        :to_user_id => 2
      )
    ])
  end

  it "renders a list of manage/friends" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
