require 'spec_helper'

describe "chunks/new" do
  before(:each) do
    assign(:chunk, stub_model(Chunk,
      :order_id => 1,
      :bean_id => 1,
      :quantity => 1.5
    ).as_new_record)
  end

  it "renders new chunk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => chunks_path, :method => "post" do
      assert_select "input#chunk_order_id", :name => "chunk[order_id]"
      assert_select "input#chunk_bean_id", :name => "chunk[bean_id]"
      assert_select "input#chunk_quantity", :name => "chunk[quantity]"
    end
  end
end
