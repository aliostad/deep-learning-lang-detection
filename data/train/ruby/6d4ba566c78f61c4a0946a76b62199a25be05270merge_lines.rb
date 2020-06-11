require "codnar"
require "olag/test"
require "test/spec"

# Test merging classified lines to chunks.
class TestMergeLines < Test::Unit::TestCase

  include Test::WithErrors

  def test_merge_no_chunks
    lines = [ { "kind" => "code", "line" => "foo", "number" => 1, "indentation" => "", "payload" => "foo" } ]
    chunks = Codnar::Merger.chunks(@errors, "path", lines)
    @errors.should == []
    chunks.should == [ {
      "name" => "path",
      "locations" => [ { "file" => "path", "line" => 1 } ],
      "containers" => [],
      "contained" => [],
      "lines" => lines
    } ]
  end

  def test_valid_merge
    chunks = Codnar::Merger.chunks(@errors, "path", VALID_LINES)
    @errors.should == []
    chunks.should == VALID_CHUNKS
  end

  VALID_LINES = [
    { "kind" => "code",        "number" => 1,  "line" => "before top",
      "indentation" => "",     "payload" => "before top"          },
    { "kind" => "begin_chunk", "number" => 2, "line" => " {{{ top chunk",
      "indentation" => " ",    "payload" => "top chunk"           },
    { "kind" => "code",         "number" => 3, "line" => " before intermediate",
      "indentation" => " ",    "payload" => "before intermediate" },
    { "kind" => "begin_chunk", "number" => 4,  "line" => "  {{{ intermediate chunk",
      "indentation" => "  ",   "payload" => "intermediate chunk"  },
    { "kind" => "code",        "number" => 5,  "line" => "  before inner",
      "indentation" => "  ",   "payload" => "before inner"        },
    { "kind" => "begin_chunk", "number" => 6,  "line" => "   {{{ inner chunk",
      "indentation" => "   ",  "payload" => "inner chunk"         },
    { "kind" => "code",        "number" => 7,  "line" => "   inner line",
      "indentation" => "   ",  "payload" => "inner line"          },
    { "kind" => "end_chunk",   "number" => 8,  "line" => "   }}} inner chunk",
      "indentation" => "   ",  "payload" => "inner chunk"         },
    { "kind" => "code",        "number" => 9,  "line" => "  after inner",
      "indentation" => "  ",   "payload" => "after inner"         },
    { "kind" => "end_chunk",   "number" => 10, "line" => "  }}}",
      "indentation" => "  ",   "payload" => ""                    },
    { "kind" => "code",        "number" => 11, "line" => " after intermediate",
      "indentation" => " ",    "payload" => "after intermediate"  },
    { "kind" => "end_chunk",   "number" => 12, "line" => " }}} TOP CHUNK",
      "indentation" => " ",    "payload" => "TOP CHUNK"           },
    { "kind" => "code",        "number" => 13, "line" => "after top",
      "indentation" => "",     "payload" => "after top"           }
  ]

  VALID_CHUNKS = [
    { "name" => "path",
      "locations" => [ { "file" => "path", "line" => 1 } ],
      "containers" => [],
      "contained" => [ "top chunk" ],
      "lines" => [
        VALID_LINES[0].merge("indentation" => ""),
        { "kind" => "nested_chunk", "number" => 2, "line" => " {{{ top chunk",
          "indentation" => " ",     "payload" => "top chunk" },
        VALID_LINES[12].merge("indentation" => ""),
      ] },
    { "name" => "top chunk",
      "locations" => [ { "file" => "path", "line" => 2 } ],
      "containers" => [ "path" ],
      "contained" => [ "intermediate chunk" ],
      "lines" => [
        VALID_LINES[1].merge("indentation" => ""),
        VALID_LINES[2].merge("indentation" => ""),
        { "kind" => "nested_chunk", "number" => 4, "line" => "  {{{ intermediate chunk",
          "indentation" => " ",     "payload" => "intermediate chunk" },
        VALID_LINES[10].merge("indentation" => ""),
        VALID_LINES[11].merge("indentation" => ""),
      ] },
    { "name" => "intermediate chunk",
      "locations" => [ { "file" => "path", "line" => 4 } ],
      "containers" => [ "top chunk" ],
      "contained" => [ "inner chunk" ],
      "lines" => [
        VALID_LINES[3].merge("indentation" => ""),
        VALID_LINES[4].merge("indentation" => ""),
        { "kind" => "nested_chunk", "number" => 6, "line" => "   {{{ inner chunk",
          "indentation" => " ",     "payload" => "inner chunk" },
        VALID_LINES[8].merge("indentation" => ""),
        VALID_LINES[9].merge("indentation" => ""),
      ] },
    { "name" => "inner chunk",
      "locations" => [ { "file" => "path", "line" => 6 } ],
      "containers" => [ "intermediate chunk" ],
      "contained" => [],
      "lines" => [
        VALID_LINES[5].merge("indentation" => ""),
        VALID_LINES[6].merge("indentation" => ""),
        VALID_LINES[7].merge("indentation" => "")
      ] }
  ]

  def test_mismatching_end_chunk_line
    lines = [
      { "kind" => "begin_chunk", "number" => 1, "line" => "{{{ top chunk",
        "indentation" => "",     "payload" => "top chunk"     },
      { "kind" => "end_chunk",   "number" => 2, "line" => "}}} not top chunk",
        "indentation" => "",     "payload" => "not top chunk" }
    ]
    Codnar::Merger.chunks(@errors, "path", lines)
    @errors.should == [
      "#{$0}: End line for chunk: not top chunk mismatches begin line for chunk: top chunk in file: path at line: 2"
    ]
  end

  def test_missing_begin_chunk_name
    lines = [
      { "kind" => "begin_chunk", "number" => 1, "line" => "{{{", "indentation" => "", "payload" => "" },
      { "kind" => "end_chunk",   "number" => 2, "line" => "}}}", "indentation" => "", "payload" => "" }
    ]
    Codnar::Merger.chunks(@errors, "path", lines)
    @errors.should == [ "#{$0}: Begin line for chunk with no name in file: path at line: 1" ]
  end

  def test_missing_end_chunk_line
    lines = [ { "kind" => "begin_chunk", "number" => 1, "line" => "{{{ top chunk",
                "indentation" => "",     "payload" => "top chunk" } ]
    Codnar::Merger.chunks(@errors, "path", lines)
    @errors.should == [ "#{$0}: Missing end line for chunk: top chunk in file: path at line: 1" ]
  end

end
