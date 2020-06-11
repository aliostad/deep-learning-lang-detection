require_relative 'streaminfo'
require_relative 'util'
require_relative 'id3/util'
require_relative 'id3/id3data'

module Mutagen
  module AIFF
    class AIFFError < RuntimeError
    end
    class InvalidChunk < IOError
    end

    # based on stdlib's aifc
    HUGE_VAL = 1.79769313486231e+308

    def self.read_float(s) # 10 bytes
      expon, himant, lomant = s.unpack('s>L>L>')
      sign = 1
      if expon < 0
        sign = -1
        expon = expon + 0x8000
      end
      f = if  expon == 0 and expon == himant and expon == lomant
            0.0
          elsif expon == 0x7FFF
            HUGE_VAL
          else
            expon -= 16383
            (himant * 0x100000000 + lomant) * (2.0** (expon - 63))
          end
      sign * f
    end

    # Representation of a single IFF chunk
    class IFFChunk

      attr_reader :parent_chunk, :offset, :size, :data_offset, :data, :data_size, :id

      # Chunk headers are 8 bytes long (4 for ID and 4 for the size)
      HEADER_SIZE = 8

      def initialize(fileobj, parent_chunk=nil)
        @fileobj = fileobj
        @parent_chunk = parent_chunk
        @offset = fileobj.pos

        header = fileobj.read HEADER_SIZE

        raise InvalidChunk if header.nil? or header.size < HEADER_SIZE

        @id, @data_size = header.unpack 'a4i>'
        raise InvalidChunk if @id == "\x00" * 4

        @size = HEADER_SIZE + @data_size
        @data_offset = fileobj.pos
        @data = nil
      end

      # Read the chunk's data
      def read
        @fileobj.seek @data_offset
        @data = @fileobj.read @data_size
      end

      # Removes the chunk from the file
      def delete
        Mutagen::Util::delete_bytes(@fileobj, @size, @offset)
        @parent_chunk.resize(@parent_chunk.data_size - @size) unless @parent_chunk.nil?
      end

      # Update the size of the chunk
      def resize(data_size)
        @fileobj.seek(@offset + 4)
        @fileobj.write([data_size].pack('I>'))
        unless @parent_chunk.nil?
          size_diff = @data_size - data_size
          @parent_chunk.resize(@parent_chunk.data_size - size_diff)
        end
        @data_size = data_size
        @size = data_size + HEADER_SIZE
      end
    end

    # Representation of a IFF file
    class IFFFile
      def initialize(fileobj)
        @fileobj = fileobj
        @chunks = {}

        # AIFF Files always start with the FORM chunk which contains a 4 byte
        # ID before the start of other chunks
        fileobj.seek(0)
        @chunks['FORM'] = IFFChunk.new(fileobj)

        # Skip past the 4 byte FORM id
        fileobj.seek(IFFChunk::HEADER_SIZE + 4)

        # Where the next chunk can be located. We need to keep track of this
        # since the size indicated in the FORM header may not match up with the
        # offset determined from the size of the last chunk in the file
        @next_offset = fileobj.pos

        # Load all of the chunks
        while true
          begin
            chunk = IFFChunk.new fileobj, self['FORM']
          rescue InvalidChunk
            break
          end

          @chunks[chunk.id.strip] = chunk

          # calculate the location of the next chunk
          # considering the pad byte
          @next_offset = chunk.offset + chunk.size
          @next_offset += @next_offset % 2
          fileobj.seek @next_offset
        end
      end

      # Check if the IFF file contains a specific chunk
      def include?(id)
        @chunks.include? id
      end

      # Get a chunk from the IFF file
      def [](id)
        @chunks[id]
      end

      # Remove a chunk from the IFF file
      def delete(id)
         @chunks.delete(id).delete if @chunks.has_key? id
      end

      def insert_chunk(id)
        @fileobj.seek(@next_offset)
        @fileobj.write [id.ljust(4),0].pack('a4i>')
        @fileobj.seek(@next_offset)
        chunk = IFFChunk.new @fileobj, self['FORM']
        self['FORM'].resize self['FORM'].data_size + chunk.size

        @chunks[id] = chunk
        @next_offset = chunk.offset + chunk.size
      end
    end

    # AIFF audio stream information
    #
    # Information is parsed from the COMM chunk of the AIFF file
    class AIFFInfo < Mutagen::StreamInfo

      # audio length, in seconds
      attr_reader :length

      # audio bitrte, in bits per seconds
      attr_reader :bitrate

      # the number of audio channels
      attr_reader :channels

      # audio sample rate, in Hz
      attr_reader :sample_rate

      # the audio sample size
      attr_reader :sample_size


      def initialize(fileobj)
        @length, @bitrate, @channels, @sample_rate = [0,0,0,0]

        iff = IFFFile.new fileobj
        common_chunk = iff['COMM']
        raise AIFFError, "#{fileobj.path} has no COMM chunk" if common_chunk.nil?

        common_chunk.read

        info = common_chunk.data[0...18].unpack('s>L>s>a10')
        channels, frame_count, sample_size, sample_rate = info

        @sample_rate = Mutagen::AIFF::read_float(sample_rate.to_s).to_i
        @sample_size = sample_size
        @channels = channels
        @bitrate = channels * sample_size * @sample_rate
        @length = frame_count / @sample_rate.to_f
      end

      def pprint
        "#{@channels} channel AIFF @ #{@bitrate} bps, #{sample_rate} Hz, %.2f seconds" % [@length]
      end

      alias_method :to_s, :pprint
    end

    class IFFID3 < Mutagen::ID3::ID3Data
      def load_header
         begin
           chunk = IFFFile.new(@fileobj)['ID3']
           raise Mutagen::ID3::ID3Error if chunk.nil?
         rescue InvalidChunk
           raise Mutagen::ID3::ID3Error
         end
        @fileobj.seek chunk.data_offset
        super
      end

      # Save ID3v2 data to the AIFF file
      def save(filename=@filename, v2_version:4, v23_sep:'/')
        framedata = prepare_framedata(v2_version, v23_sep)
        framesize = framedata.size

        # Unlike the parent ID3.save method, we won't save to a blank file
        # since we would have to construct a empty AIFF file
        File.open(filename, 'rb+') do |fileobj|
          iff_file = IFFFile.new(fileobj)

          iff_file.insert_chunk('ID3') unless iff_file.include? 'ID3'

          chunk = iff_file['ID3']
          fileobj.seek chunk.data_offset

          header = fileobj.read(10) || ''
          header = prepare_id3_header header, framesize, v2_version
          header, new_size, _ = header

          data = header + framedata + ("\x00" * (new_size - framesize))

          # Include ID3 header size in 'new_size' calculation
          new_size += 10

          # Expand the chunk if necessary, including the pad byte
          if new_size > chunk.size
            insert_at = chunk.offset + chunk.size
            insert_size = new_size - chunk.size + new_size % 2
            Mutagen::Util::insert_bytes fileobj, insert_size, insert_at
            chunk.resize new_size
          end

          fileobj.seek chunk.data_offset
          fileobj.write data
        end
      end

      # Completely removes the ID3 chunk from the AIFF file
      def delete_tags(filename=@filename)
        Mutagen::AIFF::delete_chunk filename
        clear
      end
    end

    # Completely removes the ID3 chunk from the AIFF file
    def self.delete_chunk(filename)
      File.open(filename, 'rb+') do |file|
        IFFFile.new(file).delete 'ID3'
      end
    end

    class AIFFData < Mutagen::FileType

      attr_reader :filename
      MIMES = %w(audio/aiff audio/x-aiff)

      def self.score(filename, fileobj, header)
        filename = filename.downcase
        starter = header.start_with?('FORM') ? 2 : 0
        ender = filename.end_with?('.aif') or
            filename.end_with?('.aiff') or
            filename.end_with?('.aifc') ? 1 : 0
        starter + ender
      end

      # Add an empty ID3 tag to the file.
      def add_tags
        if @tags.nil?
          @tags = IFFID3.new
        else
          raise AIFFError, 'an ID3 tag already exists'
        end
      end

      # Load stream and tag information from a file
      def load(filename, **kwargs)
        @filename = filename

        begin
          @tags = IFFID3.new filename, **kwargs
        rescue Mutagen::ID3::ID3Error
          @tags = nil
        end

        File.open(filename, 'rb') do |fileobj|
          @info = AIFFInfo.new fileobj
        end
      end
    end
  end
end