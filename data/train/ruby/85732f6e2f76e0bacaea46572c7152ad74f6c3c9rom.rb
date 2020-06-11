require 'rom'
require 'rom-repository'
require 'rom-sql'

module DiceOfDebt
  # A persistence facade
  module Persistence
    class ROM
      class << self
        def configuration
          @configuration ||= ::ROM::Configuration.new(:sql, Configuration.database_uri, Configuration.options)
        end

        def rom
          @rom ||= ::ROM.container(configuration)
        end

        def connection
          rom.gateways[:default].connection
        end

        def repository_for(type)
          case type
          when 'game'
            game_repository
          when 'iteration'
            iteration_repository
          when 'roll'
            roll_repository
          else
            fail "Could not find repository for #{type} resource"
          end
        end

        def game_repository
          @game_repository ||= GameRepository.new(rom)
        end

        def iteration_repository
          @iteration_repository ||= IterationRepository.new(rom)
        end

        def roll_repository
          @roll_repository ||= RollRepository.new(rom)
        end
      end
    end
  end
end
