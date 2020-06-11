require 'spec_helper'

describe Riffy::Chunk do
  let(:chunk) {Riffy::Chunk.read(File.open("bin/test.wav", "r"))}
  let(:riff_chunk) {Riffy::Chunk.read(File.open("bin/test.wav", "r"))}
  let(:riff_wave_chunk) {Riffy::Chunk.read(File.open("bin/test.wav", "r"))}
  #let(:list_chunk) {Riffy::Chunk.read(File.open("bin/sample.avi", "r")).data.chunks[0]}

  it "should have an id" do
    expect(chunk.id)
  end
  it "should have a size in bytes" do
    expect(chunk.chunk_size)
  end
  it "should have data" do
    expect(chunk.data)
  end
  
  context "when it's a RIFF chunk" do
    it "should have an id of RIFF" do
      expect(riff_chunk.id).to eql("RIFF")
    end
    it "should have a form type" do
      expect(riff_chunk.data.form_type)
    end
    it "should have its form type accessible through #form_type" do
      expect(riff_chunk.form_type)
      expect(riff_chunk.form_type).to eql(riff_chunk.data.form_type)
    end
    context "and its form type is WAVE" do
      it "should have a form type of WAVE" do
        expect(riff_wave_chunk.form_type).to eql("WAVE")
      end
      it "should have .wav metadata" do
        expect(riff_wave_chunk.wave_data)
      end
    end
  end
  
  context "when it's a LIST chunk" do
    it "should have an id of LIST" #do
      #expect(list_chunk.id).to eql("LIST")
    #end
    it "should have a form type" #do
      #expect(list_chunk.data.form_type)
    #end
    it "should have its form type accessible through #form_type" #do
      #expect(list_chunk.form_type)
      #expect(list_chunk.form_type).to eql(list_chunk.data.form_type)
    #end
  end
  
end
