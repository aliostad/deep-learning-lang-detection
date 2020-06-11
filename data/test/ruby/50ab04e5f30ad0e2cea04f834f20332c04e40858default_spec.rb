require_relative File.expand_path("../../spec_helper.rb", __FILE__)

describe "opentsdb_handler::default" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["opentsdb_handler"]["handler_path"] = "handler_file"
    end.converge(described_recipe)
  end

  it "creates the handler file" do
    expect(chef_run).to create_cookbook_file("handler_file").at_compile_time.with(
      source: "opentsdb_handler.rb",
      mode: "0600"
    )
  end

  it "enables the opentsdb handler" do
    expect(chef_run).to enable_chef_handler("Chef::Handler::OpenTSDB").at_compile_time.with(
      source: "handler_file",
      arguments: [
        {
          "metrics" => {},
          "run_status_tag" => false,
          "run_status" => {
            "elapsed_time" => false,
            "start_time" => false,
            "end_time" => false },
          "handler_path" => "handler_file"
        }
      ]
    )
  end
end
