require "peachy"

module Sevendigital

  class ReleaseManager < Manager

    def get_details(release_id, options = {})
      api_request = Sevendigital::ApiRequest.new("release/details", {:releaseId => release_id}, options)
      api_response = @api_client.operator.call_api(api_request)
      if (api_response && api_response.is_ok?)
        @api_client.release_digestor.from_xml(api_response.content.release)
      else
        raise Sevendigital::SevendigitalError
      end
    end

    def get_tracks(release_id, options = {})
      api_request = Sevendigital::ApiRequest.new("release/tracks", {:releaseId => release_id}, options)
      api_response = @api_client.operator.call_api(api_request)
      if (api_response && api_response.is_ok?)
        @api_client.track_digestor.list_from_xml(api_response.content.tracks)
      else
        raise Sevendigital::SevendigitalError
      end
    end

    def get_chart(options={})
        api_request = Sevendigital::ApiRequest.new("release/chart", {}, options)
        api_response = @api_client.operator.call_api(api_request)
        if (api_response && api_response.is_ok?)
          @api_client.chart_item_digestor.list_from_xml(api_response.content.chart)
        else
          raise Sevendigital::SevendigitalError
        end
    end

    def get_by_date(from_date = nil, to_date = nil, options = {})
      parameters = Hash.new
      parameters[:fromDate] = from_date.strftime("%Y%m%d") if from_date
      parameters[:toDate] = to_date.strftime("%Y%m%d") if to_date

      api_request = Sevendigital::ApiRequest.new("release/byDate", parameters, options)
      api_response = @api_client.operator.call_api(api_request)
      if (api_response && api_response.is_ok?)
        @api_client.release_digestor.list_from_xml(api_response.content.releases)
      else
        raise Sevendigital::SevendigitalError
      end
    end

    def get_recommendations(release_id, options = {})
      api_request = Sevendigital::ApiRequest.new("release/recommend", {:releaseId => release_id}, options)
      api_response = @api_client.operator.call_api(api_request)
      if (api_response && api_response.is_ok?)
        @api_client.release_digestor.nested_list_from_xml(api_response.content.recommendations, :recommended_item, :recommendations)
      else
        raise Sevendigital::SevendigitalError
      end
    end


    def get_top_by_tag(tags, options = {})
      api_request = Sevendigital::ApiRequest.new("release/byTag/top", {:tags => tags}, options)
      api_response = @api_client.operator.call_api(api_request)

      puts @api_client.operator
      if (api_response && api_response.is_ok?)
        @api_client.release_digestor.nested_list_from_xml( \
          api_response.content.tagged_results, :tagged_item, :tagged_results )
      else
        raise Sevendigital::SevendigitalError
      end
    end

  end

end