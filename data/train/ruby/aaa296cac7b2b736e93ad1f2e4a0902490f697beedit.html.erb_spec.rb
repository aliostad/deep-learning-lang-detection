require 'spec_helper'

describe "chunks/edit" do
  before(:each) do
    @chunk = assign(:chunk, stub_model(Chunk,
      :order_id => 1,
      :bean_id => 1,
      :quantity => 1.5
    ))
  end

  it "renders the edit chunk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chunks_path(@chunk), :method => "post" do
      assert_select "input#chunk_order_id", :name => "chunk[order_id]"
      assert_select "input#chunk_bean_id", :name => "chunk[bean_id]"
      assert_select "input#chunk_quantity", :name => "chunk[quantity]"
    end
  end
end
