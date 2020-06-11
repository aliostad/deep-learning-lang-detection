$:.concat ['.', 'application']

require 'MainSite'

require 'IndexHandler'
require 'UserHandler'
require 'PastebinHandler'
require 'EnvironmentHandler'
require 'InstructionSetReferenceHandler'
require 'DocumentHandler'

mainSite = MainSite.new

IndexHandler.new mainSite
userHandler = UserHandler.new mainSite
PastebinHandler.new mainSite
InstructionSetReferenceHandler.new mainSite
DocumentHandler.new mainSite

userHandler.addLogoutMenu

EnvironmentHandler.new mainSite

handler = lambda do |environment|
  mainSite.requestManager.handleRequest(environment)
end

run(handler)
