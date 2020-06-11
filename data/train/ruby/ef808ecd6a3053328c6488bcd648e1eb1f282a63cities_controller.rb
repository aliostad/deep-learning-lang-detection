class Api::CitiesController < Api::ApiController
  
  include Api::Cityable
  
  before_filter :assert_post
  before_filter :assert_city, only: [:list_kms]
  
  # POST /api/cities/list
  def list
    Api::Km.json_display = Api::Km::Json::List
    Api::City.json_display = Api::City::Json::List
    render json: { contents: Api::City.list }
  end
  
  def search
    Api::Km.json_display = Api::Km::Json::List
    Api::City.json_display = Api::City::Json::List
    render json: { contents: Api::City.search(params[:q], params[:km_id]) }
  end
  
  # POST /api/cities/list_kms
  def list_kms
    Api::Km.json_display = Api::Km::Json::Default
    render json: { contents: self.city.active_kms_filter }
  end
  
  
end