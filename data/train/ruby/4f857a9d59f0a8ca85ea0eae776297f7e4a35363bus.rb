module CMMongo

  class MissingHandler < StandardError; end

  class Bus
    
    def dispatch commmand
      handler = handler_for commmand
      handler.handle commmand
    end

    protected 
    def handler_for(target)
      handler_class = (handlers[target.class] ||= handler_class_for(target))
      handler_class.new
    end

    def handler_class_for(target)
      handler_name = "#{target.class.name.gsub(/Command/, '')}Handler"
      class_from_string handler_name
    rescue NameError => ex  
      raise MissingHandler.new("No handler found for #{target.class.name} (expected #{handler_name})")
    end

    def handlers
      @handlers ||= {}
    end

    private
    def class_from_string(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end

  end
end
