require 'paco/repository/base'
require 'paco/repository/google_drive'

module Paco
module Repository

  REPOSITORY_TYPE_KEY = 'PACO_REPOSITORY_TYPE'

  module Type
    GOOGLE_DRIVE = 'GOOGLE_DRIVE'
  end

  def factory(options)
    repository = nil

    case options['type']
    when Type::GOOGLE_DRIVE
      repository = GoogleDrive.new(options['email'], options['pem'], options['collection_url'])
    else
      raise 'error. undefined repository type.'
    end

    repository
  end

  module_function :factory
end
end
