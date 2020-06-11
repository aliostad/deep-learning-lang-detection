# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleToChunk < BMFF::Box::Full
  attr_accessor :entry_count, :first_chunk, :samples_per_chunk, :sample_description_index
  register_box "stsc"

  def parse_data
    super
    @entry_count = io.get_uint32
    @first_chunk = []
    @samples_per_chunk = []
    @sample_description_index = []
    @entry_count.times do
      @first_chunk << io.get_uint32
      @samples_per_chunk << io.get_uint32
      @sample_description_index << io.get_uint32
    end
  end
end
