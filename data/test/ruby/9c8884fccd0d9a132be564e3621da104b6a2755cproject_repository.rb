require 'memory_repository/models/project'
require 'memory_repository/base_repository'
require './lib/repository'

module MemoryRepository
  class ProjectRepository
    include BaseRepository

    def new(attrs = {})
      MemoryRepository::Project.new(attrs)
    end

    def create(attrs = {})
      project = new(attrs)
      save(project)
      project
    end

    def find_by_name(name)
      records.values.find { |r| r.name == name }
    end

    def find_by_id(id)
      records.values.find { |r| r.id == id }
    end

  end
end
