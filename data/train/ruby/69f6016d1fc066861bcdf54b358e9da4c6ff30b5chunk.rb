class Raiff::Chunk
  # == Constants ============================================================

  autoload(:Common, 'raiff/chunk/common')
  autoload(:Data, 'raiff/chunk/data')
  autoload(:Form, 'raiff/chunk/form')
  autoload(:SoundData, 'raiff/chunk/sound_data')

  # == Properties ===========================================================

  attr_reader :id, :size

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def initialize(file)
    @file = file
    @id = file.read(4)
    @size = file.unpack('N')[0]
  end
  
  def inspect
    "<#{self.class}\##{object_id} #{@id} #{@size}>"
  end
end
