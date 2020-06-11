require 'test/unit'
require 'edifact_converter'
require_relative 'log_reader_handler'


module EdifactConverter::EDI2XML11

  class BrevHandlerTest < Test::Unit::TestCase

    def log_handler
      @log_handler ||= LogReaderHandler.new
    end

    def handler
      @handler ||= BrevHandler.new log_handler
    end

    def reader
      @reader ||= EdiReader.new handler
    end

    def setup
      handler.startDocument
    end

    def test_all
      handler.startDocument
      assert not(handler.brev?)
      assert not(handler.indhold?)
      handler.locator = Locator.new
      handler.locator.position = "Pos"
      handler.startSegment("UNH")
      assert_equal 1, log_handler.number_of(:segment_group)
      assert_equal 'Brev', log_handler.last[:segment_group].value
      assert_equal 'Pos', log_handler.last[:segment_group].position
      assert_equal 'UNH', log_handler.last[:segment].value
      assert_equal 1, log_handler.number_of(:segment)
      assert_equal 1, log_handler.last[:segment_group].select(:segment).size

      handler.endSegment("UNH")
      assert_equal 2, log_handler.number_of(:segment_group)
      assert_equal 'BrevIndhold', log_handler.last[:segment_group].value
      assert_equal 'Pos', log_handler.last[:segment_group].position
      assert_equal 'UNH', log_handler.last[:segment].value
      assert_equal 1, log_handler.number_of(:segment)
      assert_equal 0, log_handler.last[:segment_group].select(:segment).size

      handler.startSegment("TST")
      assert_equal 2, log_handler.number_of(:segment_group)
      assert_equal 'BrevIndhold', log_handler.last[:segment_group].value
      assert_equal 'Pos', log_handler.last[:segment_group].position
      assert_equal 'TST', log_handler.last[:segment].value
      assert_equal 2, log_handler.number_of(:segment)
      assert_equal 1, log_handler.last[:segment_group].select(:segment).size

      handler.endSegment "TST"
      assert_equal 2, log_handler.number_of(:segment_group)
      assert_equal 'BrevIndhold', log_handler.last[:segment_group].value
      assert_equal 'Pos', log_handler.last[:segment_group].position
      assert_equal 'TST', log_handler.last[:segment].value
      assert_equal 2, log_handler.number_of(:segment)
      assert_equal 1, log_handler.last[:segment_group].select(:segment).size

      handler.startSegment("UNT")
      assert_equal 2, log_handler.number_of(:segment_group)
      assert_equal 'BrevIndhold', log_handler.last[:segment_group].value
      assert_equal 'Pos', log_handler.last[:segment_group].position
      assert_equal 'UNT', log_handler.last[:segment].value
      assert_equal 3, log_handler.number_of(:segment)
      assert_equal 1, log_handler.last[:segment_group].select(:segment).size

      handler.endSegment("UNT")
      assert_equal 2, log_handler.number_of(:segment_group)
      assert_equal 'Pos', log_handler.last[:segment_group].position
      assert_equal 'UNT', log_handler.last[:segment].value
      assert_equal 3, log_handler.number_of(:segment)
      assert_equal 3, log_handler.document.select(:segment).size
      assert_equal 2, log_handler.document.select(:segment_group).size

    end

  end

end
