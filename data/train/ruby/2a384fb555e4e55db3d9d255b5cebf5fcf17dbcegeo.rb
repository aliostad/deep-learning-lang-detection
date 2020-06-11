class Geo
  def initialize(my_location, locations=[])
    @my_location = my_location
    @locations = locations
    @range = []
  end
  
  def find_close_by_coordinates
    @locations.map do |location|
      @range << { :location_id => location.id, :distance => calculate(location) }
    end
    @range.sort_by { |k| k[:distance]}
  end
  
  private
  def calculate(location)
    CalculationCoordinate.new(
      @my_location.latitude, location.latitude, 
      @my_location.longitude, location.longitude).calculate
  end
end