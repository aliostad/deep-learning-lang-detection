#require 'spec_helper'
#
#describe "text_repositories/edit" do
#  before(:each) do
#    @text_repository = assign(:text_repository, stub_model(TextRepository,
#      :user_id => 1,
#      :repository_type_id => "MyString",
#      :name => "MyString",
#      :description => "MyString"
#    ))
#    @view.stub(:current_user).and_return(
#      FactoryGirl.create(:tanaka)
#    )
#    @view.stub(:current_locale).and_return("ja")
#
#  end
#
#  it "renders the edit text_repository form" do
#    render
#
#    # Run the generator again with the --webrat flag if you want to use webrat matchers
#    assert_select "form", :action => user_text_repositories_path(@view.current_user, @text_repository), :method => "post" do
#      assert_select "input#text_repository_user_id", :name => "text_repository[user_id]"
#      #assert_select "input#text_repository_repository_type_id", :name => "text_repository[repository_type_id]"
#      assert_select "input#text_repository_name", :name => "text_repository[name]"
#      assert_select "input#text_repository_description", :name => "text_repository[description]"
#    end
#  end
#end
