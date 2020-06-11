module DataMapper
  module Persevere
    module JSONSupport
      module Model   
        def to_json_hash(repository_name = default_repository_name)
          schema_hash = super
          schema_hash['id'] = self.storage_name(repository_name)
          schema_hash['prototype'] ||= {}
          return schema_hash
        end
        
        def to_json_schema(repository_name = default_repository_name)
          to_json(repository_name)
        end
        
        def to_json_schema_hash(repository_name = default_repository_name)
          to_json_hash(repository_name)
        end
      end # JSONSchema
    end # Model
  end # Persevere
end # DataMapper