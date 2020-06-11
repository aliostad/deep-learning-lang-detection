module FreeboxApi
end

require 'freebox_api/configuration'
require 'freebox_api/configuration/connection'
require 'freebox_api/configuration/dhcp'
require 'freebox_api/configuration/freeplug'
require 'freebox_api/configuration/ftp'
require 'freebox_api/configuration/lan'
require 'freebox_api/configuration/nat'

require 'freebox_api/freebox'
require 'freebox_api/session'
require 'freebox_api/version'
resource_files = Dir[File.expand_path("#{File.dirname(__FILE__)}/freebox_api/resources/*.rb", __FILE__)]
resource_files.each { |f| require f }
