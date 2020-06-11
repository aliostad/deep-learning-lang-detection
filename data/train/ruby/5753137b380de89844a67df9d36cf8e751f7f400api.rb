require 'naka/api/manager'
require 'naka/api/base'
require 'naka/api/client'
require 'naka/api/master'
require 'naka/old_api/ships'
require 'naka/old_api/fleets'
require 'naka/old_api/docks'
require 'naka/old_api/repair'
require 'naka/old_api/mission'
require 'naka/old_api/supply'
require 'naka/old_api/factory'
require 'naka/old_api/quest'
require 'naka/api/factory'
require 'naka/api/status'
require 'naka/api/practice'
require 'naka/api/battle'
require 'naka/api/deck'
require 'naka/api/ship'

module Naka
  module Api
    def api
      @api_manager ||= Manager.new(self)
    end
  end

  User.send(:include, Api)
end

module Naka
  class User
    include Naka::OldApi::Ships
    include Naka::OldApi::Docks
    include Naka::OldApi::Repair
    include Naka::OldApi::Mission
    include Naka::OldApi::Fleets
    include Naka::OldApi::Supply
    include Naka::OldApi::Factory
    include Naka::OldApi::Quest
  end
end
