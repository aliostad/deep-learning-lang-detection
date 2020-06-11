module Naka
  module Api
    class Factory < Naka::Api::Manager
      Naka::Api::Manager.register(:factory, self)

      class Ship < Naka::Api::Base
        def create(fuel = 30, bullet = 30, iron = 30, bauxite = 30, cheat = true, dock_id = 1)
          request "/kcsapi/api_req_kousyou/createship", api_item1: fuel, api_item2: bullet, api_item3: iron, api_item4: bauxite, api_item5: 1, api_large_flag: 0, api_kdock_id: dock_id, api_highspeed: (cheat ? 1 : 0)
          get(dock_id) if cheat
        end

        def get(dock_id)
          request "/kcsapi/api_req_kousyou/getship", api_kdock_id: dock_id
        end
      end

      class Weapon < Naka::Api::Base
        def all
          @all ||= begin
                     response = request "/kcsapi/api_get_master/slotitem"
                     response[:api_data].map{|x| OpenStruct.new(x) }
                   end
        end

        def find(id)
          all.detect{|x| x.api_id == id}
        end

        def create(fuel = 10, bullet = 10, iron = 10, bauxite = 10)
          request "/kcsapi/api_req_kousyou/createitem", api_item1: fuel, api_item2: bullet, api_item3: iron, api_item4: bauxite
        end
      end
      register :ship, Ship
      register :weapon, Weapon
    end
  end
end
