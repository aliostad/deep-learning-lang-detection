# -*- coding: utf-8 -*-
#
# Copyright (C) 2014 Droonga Project
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License version 2.1 as published by the Free Software Foundation.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require "coolio"

require "droonga/loggable"
require "droonga/timestamp"

module Droonga
  class BufferedTCPSocket < Coolio::TCPSocket
    include Loggable

    class AlreadyInWritingByOthers < StandardError
    end

    def initialize(socket, data_directory)
      super(socket)
      @data_directory = data_directory
      @_write_buffer = []
    end

    def on_connect
      logger.trace("connected to #{@remote_host}:#{@remote_port}")
    end

    def write(data)
      chunk = Chunk.new(:directory => @data_directory,
                        :data      => data)
      chunk.buffering
      @_write_buffer << chunk
      schedule_write
      data.bytesize
    end

    def on_writable
      until @_write_buffer.empty?
        chunk = @_write_buffer.shift
        begin
          chunk.writing
          logger.trace("Sending...", :data => chunk.data)
          written_size = @_io.write_nonblock(chunk.data)
          if written_size == chunk.data.bytesize
            chunk.written
            logger.trace("Completely sent.")
          else
            chunk.written_partial(written_size)
            logger.trace("Partially sent. Retry later.",
                         :written => written_size,
                         :rest    => chunk.data.bytesize)
            @_write_buffer.unshift(chunk)
            break
          end
        rescue AlreadyInWritingByOthers
          logger.trace("Chunk is already in sending by another process.")
        rescue Errno::EINTR
          @_write_buffer.unshift(chunk)
          chunk.failed
          logger.trace("Failed to send chunk. Retry later.",
                       :chunk => chunk,
                       :errpr => "Errno::EINTR")
          return
        rescue SystemCallError, IOError, SocketError => exception
          @_write_buffer.unshift(chunk)
          chunk.failed
          logger.trace("Failed to send chunk. Retry later.",
                       :chunk => chunk,
                       :exception => exception)
          return close
        end
      end

      if @_write_buffer.empty?
        disable_write_watcher
        on_write_complete
      end
    end

    def resume
      @_write_buffer = (load_chunks + @_write_buffer).sort_by do |chunk|
        chunk.time_stamp
      end
    end

    private
    def load_chunks
      FileUtils.mkdir_p(@data_directory.to_s)
      chunk_loader = ChunkLoader.new(@data_directory)
      chunk_loader.load
    end

    def log_tag
      "[#{Process.ppid}] buffered-tcp-socket"
    end

    class ChunkLoader
      def initialize(path)
        @path = path
      end

      def have_any_chunk?
        @path.opendir do |dir|
          dir.each do |entry|
            return true if entry.end_with?(Chunk::SUFFIX)
          end
        end
        false
      end

      def load
        Pathname.glob("#{@path}/*#{Chunk::SUFFIX}").collect do |chunk_path|
          Chunk.load(chunk_path)
        end
      end
    end

    class Chunk
      SUFFIX = ".chunk"
      WRITING_SUFFIX = ".writing"

      class << self
        def load(path)
          data_directory = path.dirname
          time_stamp1, time_stamp2, uniqueness, revision, = path.basename.to_s.split(".", 5)
          data = path.open("rb") {|file| file.read}
          time_stamp = Time.iso8601("#{time_stamp1}.#{time_stamp2}")
          revision = Integer(revision)
          new(:directory  => data_directory,
              :data       => data,
              :time_stamp => time_stamp,
              :uniqueness => uniqueness,
              :revision   => revision)
        end
      end

      attr_reader :data, :time_stamp
      def initialize(params)
        @data_directory = params[:directory]
        @data = params[:data]
        @time_stamp = params[:time_stamp] || Time.now
        @uniqueness = params[:uniqueness]
        @revision = params[:revision] || 0
      end

      def buffering
        path.open("wb") do |file|
          file.write(@data)
        end
      end

      def writing
        raise AlreadyInWritingByOthers.new if writing?
        FileUtils.mv(path.to_s, writing_path.to_s)
      end

      def writing?
        not path.exist?
      end

      def failed
        return unless writing?
        FileUtils.mv(writing_path.to_s, path.to_s)
      end

      def written
        FileUtils.rm_f(path.to_s)
        FileUtils.rm_f(writing_path.to_s)
      end

      def written_partial(size)
        written
        @data = data[size..-1]
        @revision += 1
        buffering
      end

      private
      def path
        @path ||= create_chunk_file_path
      end

      def writing_path
        @writing_path ||= Pathname("#{path.to_s}#{WRITING_SUFFIX}")
      end

      def create_chunk_file_path
        basename = Timestamp.stringify(@time_stamp)
        if @uniqueness
          @data_directory + "#{basename}.#{@uniqueness}.#{@revision}#{SUFFIX}"
        else
          Path.unique_file_path(@data_directory, basename, "#{@revision}#{SUFFIX}")
        end
      end
    end
  end
end
