require 'spec_helper'

describe "time_chunks/edit" do
  before(:each) do
    @time_chunk = assign(:time_chunk, stub_model(TimeChunk,
      :source_id => "MyString",
      :date_time => ""
    ))
  end

  it "renders the edit time_chunk form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => time_chunks_path(@time_chunk), :method => "post" do
      assert_select "input#time_chunk_source_id", :name => "time_chunk[source_id]"
      assert_select "input#time_chunk_date_time", :name => "time_chunk[date_time]"
    end
  end
end
