require "active_record"
require "acts-as-taggable-on"

db_yaml = File.join(Rails.root, '/config/database.yml')
dbconfig = YAML::load(File.open(db_yaml))

ActiveRecord::Base.establish_connection(dbconfig[Rails.env])

require 'artisan/repository'
require 'artisan-ar-repository/story_repository'
require 'artisan-ar-repository/project_repository'
require 'artisan-ar-repository/iteration_repository'
require 'artisan-ar-repository/future_user_repository'
require 'artisan-ar-repository/member_repository'
require 'artisan-ar-repository/project_configuration_repository'
require 'artisan-ar-repository/change_repository'
require 'artisan-ar-repository/user_repository'

module ArtisanArRepository

  def self.story
    @story_repo ||= StoryRepository.new
  end

  def self.project
    @project_repo ||= ProjectRepository.new
  end

  def self.iteration
    @iteration_repo ||= IterationRepository.new
  end

  def self.user
    @user_repo ||= UserRepository.new
  end

  def self.future_user
    @future_user_repo ||= FutureUserRepository.new
  end

  def self.member
    @member_repo ||= MemberRepository.new
  end

  def self.project_configuration
    @project_config_repo ||= ProjectConfigurationRepository.new
  end

  def self.change
    @change_repo ||= ChangeRepository.new
  end
end

Artisan::Repository.register_repo(ArtisanArRepository)
