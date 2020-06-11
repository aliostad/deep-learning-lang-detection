require 'spec_helper'

describe "chunks/edit.html.haml" do
  before(:each) do
    @chunk = assign(:chunk, stub_model(Chunk,
      :document => nil,
      :first_char_at => 1,
      :last_char_at => 1
    ))
  end

  it "renders the edit chunk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chunks_path(@chunk), :method => "post" do
      assert_select "input#chunk_document", :name => "chunk[document]"
      assert_select "input#chunk_first_char_at", :name => "chunk[first_char_at]"
      assert_select "input#chunk_last_char_at", :name => "chunk[last_char_at]"
    end
  end
end
