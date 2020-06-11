require 'football_memory_repository'

environment = "test"

#this methods routes requests to an in-memory persistence strategy. 
if (environment == "production")
  FootballRepository::Repository.register(:team, FootballArRepository::TeamRepo.new) 
  FootballRepository::Repository.register(:game, FootballArRepository::GameRepo.new) 
  FootballRepository::Repository.register(:play, FootballArRepository::PlayRepo.new)   
else 
  FootballRepository::Repository.register(:team, FootballMemoryRepository::TeamRepo.new)
  FootballRepository::Repository.register(:game, FootballMemoryRepository::GameRepo.new)  
  FootballRepository::Repository.register(:play, FootballMemoryRepository::PlayRepo.new)    
end
