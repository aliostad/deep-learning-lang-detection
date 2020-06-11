require "codnar"
require "olag/test"
require "test/spec"
require "test_with_configurations"

# Test built-in split code formatting configurations.
class TestSplitChunkConfigurations < Test::Unit::TestCase

  include Test::WithConfigurations
  include Test::WithErrors
  include Test::WithTempfile

  CODE_TEXT = <<-EOF.unindent.gsub("#!", "#")
    int x;
    #! {{{ chunk
    int y;
    #! }}}
  EOF

  CODE_HTML = <<-EOF.unindent.chomp
    <pre class='code'>
    int x;
    </pre>
    <pre class='nested chunk'>
    <a class='nested chunk' href='#chunk'>chunk</a>
    </pre>
  EOF

  CHUNK_HTML = <<-EOF.unindent.chomp
    <pre class='code'>
    int y;
    </pre>
  EOF

  def test_gvim_chunks
    check_split_file(CODE_TEXT,
                     Codnar::Configuration::CLASSIFY_SOURCE_CODE.call("c"),
                     Codnar::Configuration::CHUNK_BY_VIM_REGIONS) do |path|
      [ {
        "name"=> path,
        "locations" => [ { "file" => path, "line" => 1 } ],
        "containers" => [],
        "contained" => [ "chunk" ],
        "html"=> CODE_HTML,
      }, {
        "name" => "chunk",
        "locations" => [ { "file" => path, "line" => 2 } ],
        "containers" => [ path ],
        "contained" => [],
        "html" => CHUNK_HTML,
      } ]
    end
  end

end
