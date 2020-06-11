class BartURLBuilder
  def initialize(origin, destination)
    @api_key = "MW9S-E7SL-26DU-VV8V"
    @origin = origin
    @destination = destination
  end

  def build_routes_api_call
    "http://api.bart.gov/api/sched.aspx?cmd=depart&orig=#{@origin}&dest=#{@destination}&key=#{@api_key}"
  end

  def build_endpoint_api_call(route_number)
  "http://api.bart.gov/api/route.aspx?cmd=routeinfo&route=#{route_number}&key=#{@api_key}"
  end

  def build_realtime_departures_api_call
    "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=#{@origin}&key=#{@api_key}"
  end

  def build_stations_api_call
    "http://api.bart.gov/api/stn.aspx?cmd=stns&key=#{@api_key}"
  end
end

