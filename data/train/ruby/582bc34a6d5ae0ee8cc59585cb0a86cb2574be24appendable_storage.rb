module Paperclip
  module Storage
    module Appendable
      include Filesystem

      def chunk
        @instance.send(@options[:chunk_attr] || "#{name}_chunk")
      end

      def eof
        @eof = @instance.send(@options[:eof_attr] || "#{name}_eof")
      end

      def flush_writes
        @queued_for_write.each do |style_name, file|
          FileUtils.mkdir_p(File.dirname(path(style_name)))
          if chunk.nil? or chunk.to_i == 1
            file.close
            log("saving #{path(style_name)} (first chunk)")
            FileUtils.mv(file.path, path(style_name))
            FileUtils.chmod(0644, path(style_name))
          else
            log("appending #{path(style_name)} (chunk #{chunk})")
            File.open(path(style_name), 'a+') do |f|
              file.rewind
              while ! file.eof?
                f.write(file.read(1048576)) # 1MB blocks
              end
              file.close
            end
          end
        end
        @queued_for_write = {}
      end

      def flush_deletes
        super if chunk.nil? or chunk.to_i == 1
      end
    end
  end
end
