module Synapse
  module ProcessManager
    module Mongo
      # Implementation of a process repository that serializes process instances to an
      # underlying MongoDB collection
      class MongoProcessRepository < ProcessRepository
        # @return [ResourceInjector]
        attr_accessor :resource_injector

        # @param [Serializer] serializer
        # @param [Template] template
        # @return [undefined]
        def initialize(serializer, template)
          @resource_injector = ResourceInjector.new
          @serializer = serializer
          @template = template
        end

        # @param [Class] type
        # @param [Correlation] correlation
        # @return [Set]
        def find(type, correlation)
          process_type = @serializer.type_for(type).name

          query = {
            type: process_type,
            correlations: {
              key: correlation.key,
              value: correlation.value
            }
          }

          identifiers = Set.new
          identifiers.tap do
            cursor = @template.process_collection.find query
            cursor.each do |process|
              identifiers.add process.fetch '_id'
            end
          end
        end

        # @param [String] id
        # @return [Process] Returns nil if process could not be found
        def load(id)
          hash = @template.process_collection.find_one _id: id

          if hash
            document = ProcessDocument.new
            document.from_hash(hash).to_process(@serializer).tap do |loaded_process|
              @resource_injector.inject_resources(loaded_process)
            end
          end
        end

        # @param [Process] process
        # @return [undefined]
        def commit(process)
          if process.active?
            @template.process_collection.save to_hash process
          else
            @template.process_collection.remove _id: process.id
          end
        end

        # @param [Process] process
        # @return [undefined]
        def add(process)
          if process.active?
            @template.process_collection.insert to_hash process
          end
        end

      private

        # Marks a process's correlations as committed and converts it to a hash suitable for
        # insertion or update in a Mongo collection
        #
        # @param [Process] process
        # @return [Hash]
        def to_hash(process)
          process.correlations.commit

          document = ProcessDocument.new
          document.from_process process, @serializer
          document.to_hash
        end
      end # MongoProcessRepository
    end # Mongo
  end # ProcessManager
end
