require_relative '../spec_helper.rb'

describe Chunk do
  describe "initialization" do
    it "initializes a chunk to be uploaded" do
      file = Tempfile.new([rand(999).to_s, '.ext'])
      chunk = Chunk.new(File.dirname(file), File.basename(file))
      chunk.file_name.must_equal File.basename(file)
    end
  end

  describe "append_chunk" do
    it "appends a file chunk to the existing file" do
      #create chunk, and an existing file
      create_file("./test.txt", "source")
      create_file("./test.txt.part", "target")

      # source = Tempfile.new('test.txt')
      # source.write('source')
      # target = Tempfile.new('test.txt.part')
      # target.write('target')

      Chunk.append_chunk('./test.txt', '.', 'test.txt')
      result = File.read("./test.txt.part")
      result.must_equal "targetsource" #concatenated content of a chunk and a target file

      #cleanup
      File.unlink('./test.txt')
      File.unlink('./test.txt.part')
    end

    it "creates a partial file, when there is no existing file" do
      create_file("./test.txt", "source")

      Chunk.append_chunk('./test.txt', '.', 'test.txt')
      File.exists?('./test.txt.part').must_equal true

      #cleanup
      File.unlink('./test.txt')
      File.unlink('./test.txt.part')
    end
  end

  describe "upload" do
    before do
      random_name = rand.to_s
      @chunk = mock_upload("./#{random_name}", 'firstchunk')
      @upload_dir = "uploads_test_#{rand.to_s}" #random upload dir name
      Dir.mkdir(@upload_dir)
    end

    it "uploads the chunk" do
      # mock upload half of the file
      content_range = create_content_range(0, @chunk[:tempfile].size/2, @chunk[:tempfile].size)
      Chunk.upload(@chunk, content_range)
      File.exists?("#{@upload_dir}/#{@chunk[:filename]}.part").must_equal true
    end

    it "doesn't upload a chunk that is already uploaded" do
      #upload once
      content_range = create_content_range(0, @chunk[:tempfile].size/2, @chunk[:tempfile].size)
      Chunk.upload(@chunk, content_range)

      #attempt to upload the same chunk again
      content_range = create_content_range(0, @chunk[:tempfile].size/2, @chunk[:tempfile].size)
      Chunk.upload(@chunk, content_range)

      #partial file must not have the size doubled
      File.size?("#{@upload_dir}/#{@chunk[:filename]}.part").must_equal @chunk[:tempfile].size
    end

    it "corrects the filename when the last chunk is uploaded" do
      #mock upload the whole file
      content_range = create_content_range(0, @chunk[:tempfile].size-1, @chunk[:tempfile].size)

      Chunk.upload(@chunk, content_range)
      File.exists?("#{@upload_dir}/#{@chunk[:filename]}").must_equal true #without .part at the end!

      #cleanup
      File.unlink("#{@upload_dir}/#{@chunk[:filename]}")
    end

    #cleanup
    after do
      File.unlink(@chunk[:tempfile])

      if File.exists?("#{@upload_dir}/#{@chunk[:filename]}.part")
        File.unlink("#{@upload_dir}/#{@chunk[:filename]}.part")
      end

      Dir.unlink(@upload_dir)
    end
  end

  describe "check" do
    before do
      @random_name = rand.to_s
      @upload_dir = "uploads_test_#{rand.to_s}" #random upload dir name
      Dir.mkdir(@upload_dir)
      #file must have .part at the end, because Chunkfile.check() only checks existing uploads, not finished files
      create_file("#{@upload_dir}/#{@random_name}.part", "testfile")
    end

    it "returns an array with filesize and filename" do
      expected = {size: File.size("#{@upload_dir}/#{@random_name}.part"), name: @random_name}
      result = Chunk.check(@upload_dir, @random_name)
      result.must_equal expected
    end

    after do
      File.unlink("#{@upload_dir}/#{@random_name}.part")
      Dir.unlink(@upload_dir)
    end
  end
end
