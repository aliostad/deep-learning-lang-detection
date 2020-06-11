class BrooklynArtwork
  attr_accessor :id, :location, :title, :object_date, :medium, :label, :collection, :description,
  :image_uri, :bk_uri, :artist_name, :artist_nationality

  def initialize api_data
    @id = api_data["id"]
    @location = api_data["location"]
    @title = api_data["title"]
    @object_date = api_data["object_date"]
    @medium = api_data["medium"]
    @label = api_data["label"]
    @collection = api_data["collection"]
    @description = api_data["description"]
    @image_uri = api_data["images"]["image"]["uri"]
    @bk_uri = api_data["uri"]
    if api_data["artists"]["artist"][0].nil?
      @artist_name = api_data["artists"]["artist"]["name"]
      @artist_nationality = api_data["artists"]["artist"]["nationality"]
    else
      @artist_name = api_data["artists"]["artist"][0]["name"]
      @artist_nationality = api_data["artists"]["artist"][0]["nationality"]
    end
  end # initialize
end # BrooklynArtwork
