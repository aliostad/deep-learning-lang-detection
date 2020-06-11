module Synapse
  module ProcessManager
    module Mongo
      # Mongo document that represents a process instance
      class ProcessDocument
        # @param [Process] process
        # @param [Serializer] serializer
        # @return [ProcessDocument]
        def from_process(process, serializer)
          serialized_process = serializer.serialize process, String

          @id = process.id
          @serialized = serialized_process.content
          @type = serialized_process.type.name
          @correlations = Array.new

          process.correlations.each do |correlation|
            correlation_hash = {
              key: correlation.key,
              value: correlation.value
            }

            @correlations.push correlation_hash
          end

          self
        end

        # @param [Hash] hash
        # @return [ProcessDocument]
        def from_hash(hash)
          hash.symbolize_keys!

          @id = hash.fetch :_id
          @serialized = hash.fetch :serialized
          @type = hash.fetch :type
          @correlations = hash.fetch :correlations

          self
        end

        # @return [Hash]
        def to_hash
          { _id: @id,
            serialized: @serialized,
            type: @type,
            correlations: @correlations }
        end

        # @param [Serializer] serializer
        # @return [Process]
        def to_process(serializer)
          serialized_type = Serialization::SerializedType.new @type, nil
          serialized_object = Serialization::SerializedObject.new @serialized, String, serialized_type

          serializer.deserialize serialized_object
        end
      end # ProcessDocument
    end # Mongo
  end # ProcessManager
end
