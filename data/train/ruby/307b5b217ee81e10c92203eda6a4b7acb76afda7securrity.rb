require "securrity/version"
require 'virtus'

module Securrity
  autoload :Migrator, 'securrity/migrator'
  autoload :Facade, 'securrity/facade'

  autoload :BaseModel, 'securrity/models/base_model'
  autoload :User, 'securrity/models/user'
  autoload :Operation, 'securrity/models/operation'
  autoload :Role, 'securrity/models/role'
  autoload :Permission, 'securrity/models/permission'

  autoload :BaseRepository, 'securrity/repositories/base_repository'
  autoload :UserRepository, 'securrity/repositories/user_repository'
  autoload :PermissionRepository, 'securrity/repositories/permission_repository'
  autoload :RoleRepository, 'securrity/repositories/role_repository'
  autoload :OperationRepository, 'securrity/repositories/operation_repository'
end
