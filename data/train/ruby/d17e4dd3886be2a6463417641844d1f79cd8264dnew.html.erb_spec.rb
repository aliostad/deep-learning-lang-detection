require 'spec_helper'

describe "repositories/new.html.erb" do
  before(:each) do
    assign(:repository, stub_model(Repository,
      :new_record? => true,
      :name => "MyString",
      :owner_id => 1,
      :publish => false,
      :notes => "MyText"
    ))
  end

  it "renders new repository form" do
    render

    rendered.should have_selector("form", :action => admin_repositories_path, :method => "post") do |form|
      form.should have_selector("input#repository_name", :name => "repository[name]")
      form.should have_selector("input#repository_owner_id", :name => "repository[owner_id]")
      form.should have_selector("input#repository_publish", :name => "repository[publish]")
      form.should have_selector("textarea#repository_notes", :name => "repository[notes]")
    end
  end
end
