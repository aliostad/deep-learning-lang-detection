require 'rails_helper'

RSpec.describe "api/v1s/edit", :type => :view do
  before(:each) do
    @api_v1 = assign(:api_v1, Api::V1::Book.create!(
      :title => "MyString",
      :description => "MyString",
      :author => nil,
      :user => nil
    ))
  end

  it "renders the edit api_v1 form" do
    render

    assert_select "form[action=?][method=?]", api_v1_path(@api_v1), "post" do

      assert_select "input#api_v1_title[name=?]", "api_v1[title]"

      assert_select "input#api_v1_description[name=?]", "api_v1[description]"

      assert_select "input#api_v1_author_id[name=?]", "api_v1[author_id]"

      assert_select "input#api_v1_user_id[name=?]", "api_v1[user_id]"
    end
  end
end
