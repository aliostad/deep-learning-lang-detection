require 'spec_helper'

describe "manage/shifts/new" do
  before(:each) do
    assign(:manage_shift, stub_model(Manage::Shift,
      :shift_type => 1,
      :shift_name => "MyString",
      :shift_memo => "MyText"
    ).as_new_record)
  end

  it "renders new manage_shift form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", manage_shifts_path, "post" do
      assert_select "input#manage_shift_shift_type[name=?]", "manage_shift[shift_type]"
      assert_select "input#manage_shift_shift_name[name=?]", "manage_shift[shift_name]"
      assert_select "textarea#manage_shift_shift_memo[name=?]", "manage_shift[shift_memo]"
    end
  end
end
