require 'sinatra/base'

require 'plant'

module Sinatra
  module SettingsWrapper
    def port_binding(repository_name)
      Plant.settings.config['port_binding'][repository_name] rescue nil
    end

    def backup_container_number(repository_name)
      Plant.settings.config['backup_container_number'][repository_name] rescue nil
    end

    def auto_restart?(repository_name)
      flag_hash = Plant.settings.config['auto_restart']
      flag_hash.default = true # Set a default value
      flag_hash[repository_name]
    rescue
      true
    end

    def repository_path(repository_name)
      "#{Plant.settings.root}/repositories/#{repository_name}"
    end

    def volume_path(repository_name)
      "#{Plant.settings.root}/volume/#{repository_name}"
    end
  end
end
