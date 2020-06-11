require 'edifact_converter/edi2xml11'
require 'edifact_converter/debug_handler'

module EdifactConverter::EDI2XML11

  class Pipeline

    attr_accessor :handler

    def initialize
      xml_handler = XmlHandler.new
      settings = SettingsHandler.new(xml_handler)
      parent = ParentGroupHandler.new(settings)
      self.handler = BrevHandler.new(
        PropertiesHandler.new(
          SegmentGroupHandler.new(
            HiddenGroupHandler.new(parent)
          )
        )
      )
    end

    def self.handler
      xml_handler = XmlHandler.new
      settings = SettingsHandler.new(xml_handler)
      parent = ParentGroupHandler.new(settings)
      BrevHandler.new(
        PropertiesHandler.new(
          SegmentGroupHandler.new(
            HiddenGroupHandler.new(parent)
          )
        )
      )      
    end

  end

end
