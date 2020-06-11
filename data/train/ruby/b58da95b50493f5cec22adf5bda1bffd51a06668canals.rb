require 'logger'
require 'canals/core'

# a gem for managing ssh tunnel connections
module Canals
  extend self

  autoload :Repository, "canals/repository"
  autoload :Session, "canals/session"
  autoload :Config, 'canals/config'
  autoload :Version, 'canals/version'


  attr_accessor :logger

  def config
    return @config if defined?(@config)
    @config = Config.new(File.join(Dir.home, '.canals'))
  end

  def repository
    return @repository if defined?(@repository)
    @repository = Repository.new
  end

  def environments
    return @repository.environments if defined?(@repository)
    @repository = Repository.new
    @repository.environments
  end

  def session
    return @session if defined?(@session)
    @session = Session.new
  end
end

# default logger
Canals.logger = Logger.new(STDERR)
