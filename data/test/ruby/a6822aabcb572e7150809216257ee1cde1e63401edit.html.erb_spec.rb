require 'spec_helper'

describe "manage/shifts/edit" do
  before(:each) do
    @manage_shift = assign(:manage_shift, stub_model(Manage::Shift,
      :shift_type => 1,
      :shift_name => "MyString",
      :shift_memo => "MyText"
    ))
  end

  it "renders the edit manage_shift form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", manage_shift_path(@manage_shift), "post" do
      assert_select "input#manage_shift_shift_type[name=?]", "manage_shift[shift_type]"
      assert_select "input#manage_shift_shift_name[name=?]", "manage_shift[shift_name]"
      assert_select "textarea#manage_shift_shift_memo[name=?]", "manage_shift[shift_memo]"
    end
  end
end
