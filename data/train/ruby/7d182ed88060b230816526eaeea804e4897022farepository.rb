$:.unshift File.join(File.dirname(__FILE__), '.')

require 'active_support/inflector'
require 'active_support/core_ext/object'

require 'repository/criterion'
require 'repository/repository'
require 'repository/storage'
require 'repository/stash'
require 'repository/stash_storage'

module Repository
  
  def self.repositories
    (@@repositories ||= {})
  end
  
  def self.repository(klass)
    self.repositories[klass] ||= Repository.new(klass)
  end
  
  def self.[](klass)
    self.repository(klass)
  end

  def self.clear_all
    self.repositories.values.each do |r|
      r.clear
    end
  end

  def self.[]=(klass, repository)
    self.repositories[klass] = repository
  end
  
  # methods on Repository-enabled model classes that extend Repository

  def repository
    Repository[self]
  end
  
  def repository_size
    repository.size
  end
  
  def store(*args)
    repository.store(*args)
  end

  def search(*args, &block)
    repository.search(*args, &block)
  end
  
  def clear_repository
    repository.clear
  end
  
  def <<( *treasure )
    store( *treasure )
  end
  
  def [](arg)
    repository[arg]
  end

  def self.extended( klass )
    klass.class_eval do
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def store
      self.class.store(self)
    end
  end
  
end
