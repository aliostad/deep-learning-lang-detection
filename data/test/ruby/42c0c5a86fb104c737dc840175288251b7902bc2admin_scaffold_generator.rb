class AdminScaffoldGenerator < Rails::Generator::NamedBase
	attr_reader   :controller_name,
								:controller_class_path,
								:controller_file_path,
								:controller_class_nesting,
								:controller_class_nesting_depth,
								:controller_class_name,
								:controller_singular_name,
								:controller_plural_name,
								:controller_routing_name,                 # new_session_path
								:controller_routing_path,                 # /session/new
								:controller_controller_name,              # sessions
								:controller_file_name
	alias_method  :controller_table_name, :controller_plural_name
	attr_reader   :model_controller_name,
								:model_controller_class_path,
								:model_controller_file_path,
								:model_controller_class_nesting,
								:model_controller_class_nesting_depth,
								:model_controller_class_name,
								:model_controller_singular_name,
								:model_controller_plural_name,
								:model_controller_routing_name,           # new_user_path
								:model_controller_routing_path,           # /users/new
								:model_controller_controller_name         # users
	alias_method  :model_controller_file_name,  :model_controller_singular_name
	alias_method  :model_controller_table_name, :model_controller_plural_name

	def initialize(runtime_args, runtime_options = {})
	end

	def manifest
	end

end
