require "pakada"
require "pakada/repository"

require "dm-yaml-adapter"

class Pakada::Config
  include Pakada::Module
  @dependencies << Pakada::Repository

  def initialize
    P.repository.setup(:config, repository_dsn)

    P.repository.context(:config) do
      P.repository.setup_model(:config) do
        property :name,    DataMapper::Property::String, :key => true
        property :payload, DataMapper::Property::Greedy

        class << self
          define_method(:storage_name) {|*| Pakada.env }
        end
      end
    end
  end

  def repository_path
    Pakada.app.path.join("data")
  end
  
  def repository_dsn
    "yaml:#{repository_path}?records_as_list=false"
  end
end
