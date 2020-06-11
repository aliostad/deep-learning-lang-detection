require "active_record"

db_yaml = File.join(Rails.root, './config/database.yml')
dbconfig = YAML.load(File.open(db_yaml))

ActiveRecord::Base.establish_connection(dbconfig[Rails.env])

require './lib/repository'
require 'ar_repository/project_repository'
require 'ar_repository/story_repository'
require 'ar_repository/user_repository'

module ArRepository
  def self.project
    @project_repo ||= ProjectRepository.new
  end

  def self.story
    @story_repo ||= StoryRepository.new
  end

  def self.user
    @user_repo ||= UserRepository.new
  end

end

KittyKanban::Repository.register_repo(ArRepository)
