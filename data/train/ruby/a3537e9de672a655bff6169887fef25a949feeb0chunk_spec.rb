require 'spec_helper'

describe Chunk do

  before(:each) do
    @chunk = Factory(:chunk)
  end

  after(:each) do
    # FIXME for unknown reason, @chunk.source is shared between specs ?!
    @chunk.source.records.clear if @chunk.source.records.respond_to?(:clear)
  end

  it { should validate_presence_of(:begin) }
  it { should validate_presence_of(:end) }

  it { should belong_to(:source) }

  it "should have a nil completion rate" do
    Chunk.new.completion_rate.should be_nil
  end


  it "should validate that end is after begin" do
    @chunk.end = @chunk.begin - 1
    @chunk.should have(1).error_on(:end)
  end

  it "should have available records when using past records (no way they appear)" do
    @chunk.source.records.create :end => @chunk.end + 1.hour, :duration => 2.hours
    @chunk.should have(1).error_on(:begin)
    @chunk.should have(1).error_on(:end)
  end

  it "should not end after the latest record (chunk scheduling not available for the moment)" do
    @chunk.source.records.create :end => @chunk.end - 1.hour, :duration => 1.hour
    @chunk.should have(1).error_on(:end)
  end

  it "should accept to end at the latest record end" do
    @chunk.source.records.create! :begin => @chunk.begin, :end => @chunk.end, :filename => "dummy"
    @chunk.should be_valid
  end

  describe "format" do

    it "should support symbols" do
      @chunk.format = :mp3
      @chunk.format.should == :mp3
    end

    it { should allow_values_for(:format, :wav, :vorbis, :mp3) }
    it { should_not allow_values_for(:format, :wma) }

  end

  describe "file extension" do

    it "should give .ogg ext when format is :vorbis" do
      @chunk.format = :vorbis
      @chunk.file_extension.should == "ogg"
    end
    it "should give .mp3 ext when format is :mp3" do
      @chunk.format = :mp3
      @chunk.file_extension.should == "mp3"
    end
  end

  describe "status" do
    
    it "should be created when completion_rate is nil" do
      @chunk.completion_rate = nil
      @chunk.status.should be_created
    end

    it "should be pending when completion rate is between 0 and 1.0" do
      @chunk.completion_rate = 0
      @chunk.status.should be_pending
    end
    
    it "should not completed when completion rate is 1.0" do
      @chunk.completion_rate = 1.0
      @chunk.status.should be_completed
    end

  end

  describe "records" do

    before(:each) do
      @chunk.stub!(:source).and_return(mock(Source, :records => mock("source records")))

      @records = Array.new(3) { |n| mock Record, :time_range => n, :quality => 1, :end => @chunk.end-(n-4)*5.minutes}
      @chunk.source.records.stub!(:including).and_return(@records)
    end
    
    it "should retrieve source recordings including chunck begin and end" do
      @chunk.source.records.should_receive(:including).with(@chunk.begin, @chunk.end).and_return(@records)
      @chunk.records.should == @records
    end

    it "should use only uniq records (no records with the same time range)" do
      @chunk.source.records.stub!(:including).and_return(@records + @records)
      @chunk.records.should == @records
    end

    it "should return an empty array when begin is not defined" do
      @chunk.begin = nil
      @chunk.records.should be_empty
    end

    it "should return an empty array when end is not defined" do
      @chunk.end = nil
      @chunk.records.should be_empty
    end

    it "should not return an empty array when end is the last record end (#33)" do
      @chunk.source.records.stub!(:including).and_return(@records)
      @chunk.end = @records.last.end
      @chunk.records.should_not be_empty
    end
    
  end

  describe "filename" do

    it "should be :storage_directory/:sanitized_title.:format if :title defined" do
      Chunk.stub!(:storage_directory).and_return("storage_directory")
      @chunk.title = "toto et titi"
      @chunk.stub :file_extension => "ext"

      @chunk.filename.should == "storage_directory/toto_et_titi.ext"
    end

  end

  describe "storage_directory" do

    before(:each) do
      @dummy_dir = "#{Rails.root}/tmp/dummy"
      reset
    end

    it "should be configurable" do
      Chunk.storage_directory = @dummy_dir
      Chunk.storage_directory.should == @dummy_dir
    end

    Spec::Matchers.define :exist do 
      match do |file|
        File.exists? file
      end
    end

    it "should create the directory" do
      Chunk.storage_directory = @dummy_dir
      Chunk.storage_directory.should exist
    end

    def reset
      Dir.rmdir @dummy_dir if File.exists?(@dummy_dir)
      Chunk.storage_directory = nil
    end

    after(:each) do
      reset
    end

  end

  describe "file" do

    it "should return the file containing chunk content if exists" do
      File.should_receive(:exist?).with(@chunk.filename).and_return(true)
      @chunk.file.should == @chunk.filename
    end

    it "should be nil if file doesn't exist" do
      File.stub!(:exist?).and_return(false)
      @chunk.file.should be_nil
    end

  end

  describe "size" do

    it "should return the File size if exists" do
      @chunk.stub!(:file).and_return("dummy")
      File.should_receive(:size).with(@chunk.file).and_return(file_size = 10)
      @chunk.size.should == file_size
    end

    it "should return estimated size if file doesn't exist" do
      @chunk.stub!(:file)
      @chunk.stub!(:estimated_size).and_return(1.megabyte)
      @chunk.size.should == @chunk.estimated_size
    end

  end

  describe "estimated_size" do
    
    it "should be 10584000 bytes for a chunk of 1 minute" do
      @chunk.stub!(:duration).and_return(1.minute)
      @chunk.estimated_size.should == 10584000
    end

    it "should be nil if duration is unknown" do
      @chunk.stub!(:duration)      
      @chunk.estimated_size.should be_nil
    end

  end

  it "should remove file when destroyed" do
    FileUtils.touch(@chunk.filename)
    @chunk.destroy
    File.exist?(@chunk.filename).should be_false
  end

  describe "time_range" do
    
    it "should be nil if begin is nil" do
      @chunk.begin = nil
      @chunk.time_range.should be_nil
    end

    it "should be nil if end is nil" do
      @chunk.end = nil
      @chunk.time_range.should be_nil
    end

    it "should be nil if begin is after end" do
      @chunk.begin = @chunk.end + 5
      @chunk.time_range.should be_nil
    end

    it "should be chunk's begin..end when available" do
      @chunk.time_range.should == (@chunk.begin..@chunk.end)
    end

  end

  describe "create_file!" do

    before(:each) do
      @sox = mock(Sox::Command, :input => nil, :output => nil, :effect => nil)
      Sox.stub!(:command).and_yield(@sox).and_return(true)
      
      @records = Array.new(3) do |n| 
        mock(Record, :filename => "file#{n}", :duration => 10)
      end
      @records.first.stub!(:begin).and_return(@chunk.begin)

      @chunk.stub!(:records).and_return(@records)
    end

    it "should use record files as sox inputs" do
      @records.each do |record|
        @sox.should_receive(:input).with(record.filename)
      end
      @chunk.create_file!
    end

    it "should use chunk filename as sox output" do
      @sox.should_receive(:output).with(@chunk.filename, :compression => 6)
      @chunk.create_file!
    end

    it "should trim the output file when chunk duration is shorter than record files" do
      @chunk.begin = @records.first.begin
      @chunk.end = @chunk.begin + 5

      @sox.should_receive(:effect).with(:trim, 0, @chunk.duration)
      @chunk.create_file!
    end

    it "should trim the output file when chunk begins after the first record begin" do
      @chunk.begin = @records.first.begin + 5

      @sox.should_receive(:effect).with(:trim, 5, @chunk.duration)
      @chunk.create_file!
    end

    it "should be completed when file is created" do
      @chunk.create_file!
      @chunk.status.should be_completed
    end

    it "should be pending while sox is running" do
      @sox.stub!(:command).and_return do
        @chunk.status.should be_pending
        true
      end
      @chunk.create_file!
    end

    it "should be created when file creation fails" do
      Sox.stub!(:command).and_return(false)
      @chunk.create_file!
      @chunk.status.should be_created
    end

  end

  it "should check_file_status when Chunk is created" do
    @chunk = Factory.build(:chunk)
    @chunk.should_receive(:check_file_status)
    @chunk.save!
  end

  describe "delete_file" do
    
    it "should delete file if file exists" do
      @chunk.stub!(:file).and_return("file")

      File.should_receive(:delete).with(@chunk.file)
      @chunk.delete_file
    end

    it "should not delete file if file doesn't exist" do
      @chunk.stub!(:file)

      File.should_not_receive(:delete)
      @chunk.delete_file
    end

  end

  describe "check_file_status" do

    def status(string_value)
      ActiveSupport::StringInquirer.new(string_value)
    end
    
    it "should create_file later if status is created" do
      @chunk.stub!(:status).and_return(status("created"))
      @chunk.should_receive(:send_later).with(:create_file!)
      @chunk.check_file_status
    end

    it "should create_file if status is pending" do
      @chunk.stub!(:status).and_return(status("pending"))
      @chunk.should_not_receive(:send_later)
      @chunk.check_file_status
    end

  end

  it "should validate that source can store it" do
    @chunk.source.stub!(:can_store?).and_return(false)
    @chunk.should have(1).error_on(:base)
  end

end
