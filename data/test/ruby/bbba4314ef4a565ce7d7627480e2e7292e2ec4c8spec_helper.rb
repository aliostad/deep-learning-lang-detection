require 'rspec'
require 'rspec/core'
require 'dotenv'

require_relative '../core'
require_relative '../infra'
require_relative '../config'

def configure_repository_mappings
  Repository.configure(
    "Drinker"   => Repositories::Sqlite::DrinkerRepository.new,
    "Round"     => Repositories::Sqlite::RoundRepository.new,
    "Settings"  => Repositories::InMemory::BaseRepository.new
  )

  Repository.for("Drinker").cleardown! if Repository.for("Drinker").respond_to?(:cleardown!)
  Repository.for("Round").cleardown! if Repository.for("Round").respond_to?(:cleardown!)

  Repository.for("Settings").save(Settings.new)
end
