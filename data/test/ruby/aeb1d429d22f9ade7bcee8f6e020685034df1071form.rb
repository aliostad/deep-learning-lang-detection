class Raiff::Chunk::Form < Raiff::Chunk
  # == Properties ===========================================================
  
  attr_reader :chunks

  # == Class Methods ========================================================

  # == Instance Methods =====================================================
  
  def initialize(file)
    super(file)
    
    @type = file.read(4)
    
    @chunks = { }
    common_chunk = nil
    
    while (!file.eof?)
      chunk =
        case (file.peek(4))
        when 'COMM'
          common_chunk = Raiff::Chunk::Common.new(file)
        when 'SSND'
          # FIX: Raise exception when there is no common block, but
          #      a SoundData block occurs.
          Raiff::Chunk::SoundData.new(file, common_chunk)
        else
          Raiff::Chunk::Data.new(file)
        end
        
      @chunks[chunk.id] ||= [ ]
      @chunks[chunk.id] << chunk
    end
  end
end
