require 'rails_helper'

RSpec.describe "repositories/edit", :type => :view do
  before(:each) do
    @repository = assign(:repository, Repository.create!(
      :name => "MyString",
      :url => "MyString",
      :enabled => false,
      :user_id => 1
    ))
  end

  it "renders the edit repository form" do
    render

    assert_select "form[action=?][method=?]", repository_path(@repository), "post" do

      assert_select "input#repository_name[name=?]", "repository[name]"

      assert_select "input#repository_url[name=?]", "repository[url]"

      assert_select "input#repository_enabled[name=?]", "repository[enabled]"
    end
  end
end
