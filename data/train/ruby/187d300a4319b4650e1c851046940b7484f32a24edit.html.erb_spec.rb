require 'spec_helper'

describe "repositories/edit" do
  before(:each) do
    @repository = assign(:repository, stub_model(Repository,
      :organization => "",
      :name => "",
      :url => "",
      :issues_url => "MyString"
    ))
  end

  it "renders the edit repository form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", repository_path(@repository), "post" do
      assert_select "input#repository_organization[name=?]", "repository[organization]"
      assert_select "input#repository_name[name=?]", "repository[name]"
      assert_select "input#repository_url[name=?]", "repository[url]"
      assert_select "input#repository_issues_url[name=?]", "repository[issues_url]"
    end
  end
end
