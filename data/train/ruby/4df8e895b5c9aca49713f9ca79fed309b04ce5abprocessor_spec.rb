require 'spec_helper'

describe OCR::Processor do
  let(:example_file) { File.expand_path('../../../example.ocr', __FILE__)}

  subject {OCR::Processor.new(example_file)}

  it "should set the first arg to :input" do
    subject.input.should == example_file
  end

  describe :process do
    it "should chunk every four lines" do
      OCR::LineChunker.should_receive(:new).exactly(4).times
      subject.process
    end

    it "should parse each chunk" do
      mock_parser = OCR::ChunkParser.new(["","","",""])
      OCR::ChunkParser.should_receive(:new).exactly(4).times.
        and_return(mock_parser)
      subject.process
    end

    it "should return an array of [parsed, code]" do
      subject.process.should == [
        ["457508000", :ok],
        ["664371495", :err],
        ["86110??36", :ill],
        ["888888888", :err]
      ]
    end
  end

  describe :calculate_checksum do
    it "should take a string return an symbol" do
      subject.calculate_checksum("").should be_a Symbol
    end

    it "should return :ill if the string contains non-digit characters" do
      subject.calculate_checksum("12345678?").should == :ill
    end

    it "should calculate the sum" do
      subject.should_receive(:calculate_sum).with("123456789").and_return(0)
      subject.calculate_checksum("123456789")
    end

    it "should return :ok for '457508000'" do
      subject.calculate_checksum('457508000').should == :ok
    end

    it "should return :err for '457508001'" do
      subject.calculate_checksum('457508001').should == :err
    end
  end

  describe :calculate_sum do
    it "should take a string and return an integer" do
      subject.calculate_sum("").should be_a Fixnum
    end

    it "should return 1 for '1'" do
      subject.calculate_sum('1').should == 1
    end

    it "should return digit for digit as string" do
      (2..9).each {|d| subject.calculate_sum(d.to_s).should == d }
    end

    it "should return 2 for '10'" do
      subject.calculate_sum('10').should == 2
    end

    it "should modulo numbers larger than 10" do
      subject.calculate_sum('19').should_not == 11
      subject.calculate_sum('19').should == 0
    end
  end
end
