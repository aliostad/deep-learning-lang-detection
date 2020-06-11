require 'dm-chunked_query/chunks'

module DataMapper
  module ChunkedQuery
    module Mixin
      #
      # Allows chunked access to the resources from a query.
      #
      # @param [Integer] per_chunk
      #   The number of resources per-chunk.
      #
      # @return [Chunks]
      #   The abstract collection of chunks from the query.
      #
      def chunks(per_chunk)
        Chunks.new(self,per_chunk)
      end

      #
      # @see #chunks
      #
      def chunks_of(per_chunk)
        chunks(per_chunk)
      end

      #
      # Enumerate over every chunk.
      #
      # @param [Integer] per_chunk
      #   The number of resources per-chunk.
      #
      # @yield [chunk]
      #   A chunk of resources within the query.
      #
      # @yieldparam [DataMapper::Collection] chunk
      #   A collection of resources that makes up the chunk.
      #
      # @return [Chunks]
      #   The abstract collection of chunks from the query.
      #
      # @see #chunks
      #
      # @since 0.2.0
      #
      def each_chunk(per_chunk,&block)
        chunks(per_chunk).each(&block)
      end

      #
      # @see each_chunk
      #
      # @since 0.3.0
      #
      def each_slice(per_chunk,&block)
        each_chunk(per_chunk,&block)
      end

      #
      # Reads in records in batches and processes them.
      #
      # @param [Integer] per_batch
      #   The number of resources per-batch.
      #
      # @yield [resource]
      #   The given block will be passed each resource from each batch
      #   of resources.
      #
      # @yieldparam [DataMapper::Resource] resource
      #   A resource from the batch.
      #
      # @return [Chunks]
      #   The abstract collection of chunks from the query.
      #
      # @see #each_chunk
      #
      # @since 0.3.0
      #
      def batch(per_batch,&block)
        each_chunk(per_batch) { |chunk| chunk.each(&block) }
      end
    end
  end
end
