require 'test/unit'
require 'edifact_converter'
require 'equivalent-xml'


module EdifactConverter::EDI2XML11

  class XmlHandlerTest < Test::Unit::TestCase

    def test_matches_xml
      builder = Nokogiri::XML::Builder.new(:encoding => 'ISO-8859-1') do |xml|
        xml.Edifact linie: 0, position: 0 do
          xml.S01 linie: 1, position: 0 do
            xml.Elm linie: 1, position: 0 do
              xml.SubElm "01", linie: 1, position: 0
            end
            xml.UNB linie: 1, position: 0 do
              xml.Elm linie: 1, position: 0 do
                xml.SubElm "UNOC", linie: 1, position: 0
                xml.SubElm "3", linie: 1, position: 0
              end
              xml.Elm linie: 1, position: 0 do
                xml.SubElm "5790000143054", linie: 1, position: 0
                xml.SubElm "14", linie: 1, position: 0
              end
            end
          end
        end
      end
      handler = XmlHandler.new
      handler.startDocument
      handler.locator = Locator.new
      handler.locator.position = Position.new(1, 0)
      handler.startSegmentGroup "S01", false
      handler.startElement
      handler.value "01"
      handler.endElement
      handler.startSegment "UNB"
      handler.startElement
      handler.value "UNOC"
      handler.value "3"
      handler.endElement
      handler.startElement
      handler.value "5790000143054"
      handler.value "14"
      handler.endElement
      handler.endSegment 'UNOC'
      handler.endSegmentGroup 'S01'
      handler.endDocument

      assert EquivalentXml.equivalent?(handler.xml.root, builder.doc.root)
    end

    def test_bad_syntax_error
      handler = XmlHandler.new
      handler.startDocument
      handler.locator = Locator.new
      handler.locator.position = Position.new(2, 0)
      handler.startSegment "UNB"
      handler.startElement
      handler.value "UNOC"
      handler.value "3"
      #handler.endElement
      handler.startElement
      handler.value "5790000143054"
      handler.value "14"
      handler.endElement
      handler.endSegment 'UNB'
      assert_raise EdifactConverter::EdifactError do
        handler.endDocument
      end
    end

  end

end
