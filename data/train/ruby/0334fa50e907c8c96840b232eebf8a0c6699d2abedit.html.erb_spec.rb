require 'spec_helper'

describe "tengine/core/handler_paths/edit.html.erb" do
  before(:each) do
    @handler_path = assign(:handler_path, stub_model(Tengine::Core::HandlerPath,
      :event_type_name => "MyString",
      :handler_id => ""
    ))
  end

  it "renders the edit handler_path form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tengine_core_handler_paths_path(@handler_path), :method => "post" do
      assert_select "input#handler_path_event_type_name", :name => "handler_path[event_type_name]"
      assert_select "input#handler_path_handler_id", :name => "handler_path[handler_id]"
    end
  end
end
