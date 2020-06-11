require 'synapse/process_manager/correlation'
require 'synapse/process_manager/correlation_resolver'
require 'synapse/process_manager/correlation_set'
require 'synapse/process_manager/lock_manager'
require 'synapse/process_manager/pessimistic_lock_manager'
require 'synapse/process_manager/process'
require 'synapse/process_manager/process_factory'
require 'synapse/process_manager/process_manager'
require 'synapse/process_manager/process_repository'
require 'synapse/process_manager/resource_injector'
# Must be loaded after the resource injector
require 'synapse/process_manager/container_resource_injector'
require 'synapse/process_manager/simple_process_manager'

require 'synapse/process_manager/mapping/process'
require 'synapse/process_manager/mapping/process_manager'

require 'synapse/process_manager/repository/in_memory'
