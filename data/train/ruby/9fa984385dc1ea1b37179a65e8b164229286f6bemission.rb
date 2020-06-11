module Naka
  module OldApi
    module Mission
      def start_mission(deck_id, mission_id)
        api.post '/kcsapi/api_req_mission/start', api_deck_id: deck_id, api_mission_id: mission_id
      end

      def mission_result(deck_id)
        response = api.post '/kcsapi/api_req_mission/result', api_deck_id: deck_id
        case response[:api_data][:api_clear_result]
        when 0
          :failure
        when 1
          :success
        when 2
          :awesome
        else
          p response[:api_data][:api_clear_result]
          :failure
        end
      end
    end
  end
end
