module Naka
  module Api
    class Practice < Base
      def all
        response = request '/kcsapi/api_get_member/practice'
        response[:api_data].map {|x| Naka::Models::Practice.new(x) }
      end

      def deck(practice)
        response = request '/kcsapi/api_req_member/getothersdeck', api_member_id: practice.user_id
        master = @user.ships_master
        ships = response[:api_data][:api_deck][:api_ships].reject{|x| x[:api_id] == -1}.map do |x|
          ship = master.detect{|ship| ship.id == x[:api_ship_id] }
          OpenStruct.new level: x[:api_level], master: ship
        end
        deck = Naka::Models::Deck.new
        deck.ships = ships
        deck
      end

      def battle(practice)
        response = request '/kcsapi/api_req_practice/battle', api_enemy_id: practice.user_id, api_deck_id: 1, api_formation_id: 1
        Naka::Models::Battle::Battle.from_api(response)
      end

      def midnight(practice)
        request '/kcsapi/api_req_practice/midnight_battle', api_enemy_id: practice.user_id, api_formation_id: 1, api_deck_id: 0
      end

      def result
        request '/kcsapi/api_req_practice/battle_result'
      end
    end

    Manager.register :practice, Practice
  end
end
