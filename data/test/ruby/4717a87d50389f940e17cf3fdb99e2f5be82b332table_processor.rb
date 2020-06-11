require File.join(File.dirname(__FILE__), 'renaming_map_builder')
require File.join(File.dirname(__FILE__), 'table')
require File.join(File.dirname(__FILE__), 'calculate_parameter_parser')

class TableProcessor
  def self.process(table, renaming_param, calculate_param)
    renaming_map = RenamingMapBuilder.build_renaming_map_from(renaming_param)
    table.rename_columns(renaming_map)

    calculation_details = CalculateParameterParser.parse(calculate_param)
    calculation_details.each do |calculation_detail|
      table.add_calculated_column(calculation_detail)
    end
  end
end