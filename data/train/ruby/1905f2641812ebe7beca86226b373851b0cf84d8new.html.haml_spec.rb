require 'spec_helper'

describe "chunks/new.html.haml" do
  before(:each) do
    assign(:chunk, stub_model(Chunk,
      :document => nil,
      :first_char_at => 1,
      :last_char_at => 1
    ).as_new_record)
  end

  it "renders new chunk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chunks_path, :method => "post" do
      assert_select "input#chunk_document", :name => "chunk[document]"
      assert_select "input#chunk_first_char_at", :name => "chunk[first_char_at]"
      assert_select "input#chunk_last_char_at", :name => "chunk[last_char_at]"
    end
  end
end
