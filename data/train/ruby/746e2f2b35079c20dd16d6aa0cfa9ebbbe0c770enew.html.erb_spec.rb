require 'spec_helper'

describe "manage/blogs/new" do
  before(:each) do
    assign(:manage_blog, stub_model(Manage::Blog,
      :user_id => 1,
      :category_id => 1,
      :title => "MyString",
      :content => "MyText",
      :condition => 1
    ).as_new_record)
  end

  it "renders new manage_blog form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", manage_blogs_path, "post" do
      assert_select "input#manage_blog_user_id[name=?]", "manage_blog[user_id]"
      assert_select "input#manage_blog_category_id[name=?]", "manage_blog[category_id]"
      assert_select "input#manage_blog_title[name=?]", "manage_blog[title]"
      assert_select "textarea#manage_blog_content[name=?]", "manage_blog[content]"
      assert_select "input#manage_blog_condition[name=?]", "manage_blog[condition]"
    end
  end
end
