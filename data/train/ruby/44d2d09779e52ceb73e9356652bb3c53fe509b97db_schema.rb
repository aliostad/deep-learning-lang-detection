module DeployMongo

  class DbSchema
  
    def initialize(schema,repository)
      @schema = schema
      @repository = repository
    end
   
    def self.load_or_create(config,repository)
      default_schema = {"_id"=>"schema__schema_document_key__", 'applied_deltas'=>[]}
      schema = repository.get_schema
      if (schema.nil?)
         repository.save_schema(default_schema)
         schema = repository.get_schema
      end
      DbSchema.new(schema,repository)
    end
  
    def applied_deltas
      @schema["applied_deltas"]
    end

    def completed(delta)
      @schema['applied_deltas'].push(delta.id)
      @repository.save_schema(@schema)
      @schema = @repository.get_schema
    end

    def rollback(delta)
      @schema['applied_deltas'].delete(delta.id)
      @repository.save_schema(@schema)
      @schema = @repository.get_schema
    end
  
  end

end