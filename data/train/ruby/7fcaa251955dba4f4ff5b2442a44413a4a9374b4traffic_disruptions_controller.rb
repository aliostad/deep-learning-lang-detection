class Api::TrafficDisruptionsController < Api::ApiController
  
  include Api::Kmable
  
  before_filter :assert_km, only: [:chart, :map]
  
  # POST /api/traffic_disruptions/chart
  def chart
    Api::DeliveriesDisruption.json_display = Api::DeliveriesDisruption::Json::Chart
    render json: { contents: self.km.api_chart_disruptions }
  end
  
  # POST /apo/traffic_disruptions/map
  def map
    Api::TrafficDisruption.json_display = Api::TrafficDisruption::Json::Map
    render json: { contents: self.km.api_map_disruptions }
  end
  
  
end
