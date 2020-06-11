require './app/models/pet'
Dir["./lib/pets/context/*"].each {|file| require file }
require 'pets/repository/pet_repository'

module Pets
  module PetFactory

    def self.create_pet
      Pets::Context::CreatePet.new(pet_repository)
    end

    def self.find_all_pets
      Pets::Context::FindAllPets.new(pet_repository)
    end

    def self.find_by_name
      Pets::Context::FindByName.new(pet_repository)
    end

    private

    def self.pet_repository
      Pets::Repository::PetRepository.new(pet_driver)
    end

    def self.pet_driver
      ::Pet
    end

  end
end
