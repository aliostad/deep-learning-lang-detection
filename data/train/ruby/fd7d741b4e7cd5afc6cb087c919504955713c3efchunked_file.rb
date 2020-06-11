module Ubiquity

  class S3

    class MultipartUpload

      class ChunkedFile

        DEFAULT_CHUNK_SIZE = 5242880

        attr_reader :file_path, :file, :chunk_size, :indexed_chunks

        # We define a new method so that we can open the file with a variable not associated with the object in order to
        # have a working finalizer
        def self.new(args = { }, &block)
          obj = self.allocate
          #puts "obj: #{obj.inspect}"

          args[:file] ||= begin
            file_path = args[:file_path]
            file_open_args = args[:file_access] || [ ]
            file = File.new(file_path, *file_open_args)
            #puts "Opened File: #{file.object_id} #{file.inspect}"

            # Ensure that the file gets closed
            ObjectSpace.define_finalizer( obj, proc {
              #puts "Closing File: #{file.object_id} #{file.inspect}"
              file.close unless file.closed?
            } )

            file
          end

          obj.initializer(args, &block)
          obj
        end

        def initializer(args = { })
          @file = args[:file]
          @file_path = file.path
          @chunk_size = args[:chunk_size] || DEFAULT_CHUNK_SIZE

          maximum_chunks = args[:maximum_chunks]
          if maximum_chunks and total_chunks > maximum_chunks
            @chunk_size = (file.size / maximum_chunks)
            @total_chunks = nil
          end

          @indexed_chunks = { }
          @cache_enabled = args.fetch(:cache_enabled, false)
        end

        def close
          file.close if file and file.respond_to?(:close) and !file.closed?
        end

        def delete_chunk(chunk_index)
          @indexed_chunks.delete(chunk_index) { true }
        end

        def each
          return Enumerator.new(self.dup, :each_chunk) unless block_given?
          (0..(total_chunks-1)).each { |idx| yield get_chunk(idx) }
        end

        def each_with_index
          (0..(total_chunks-1)).each { |idx| yield idx, get_chunk(idx) }
        end

        def path
          @path ||= file.path
        end

        def get_chunk(chunk_index)
          if @cache_enabled
            @indexed_chunks[chunk_index] ||= get_chunk_from_file(chunk_index)
          else
            get_chunk_from_file(chunk_index)
          end
        end

        def get_chunk_from_file(chunk_index)
          byte = chunk_index * chunk_size
          #puts "Reading Chunk #{chunk_index} Byte Offset: #{byte} -> #{byte + chunk_size}"
          file.seek(byte, IO::SEEK_SET)
          file.read(chunk_size)
        end

        def size
          @size ||= file.size
        end

        def total_chunks
          @total_chunks ||= (size.to_f / chunk_size.to_f).ceil
        end

        def method_missing(method_symbol, *args, &block)
          return file.send(method_symbol, *args, &block) if file.respond_to?(method_symbol)
          super
        end

        # ChunkedFile
      end

    end

  end

end