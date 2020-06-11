require 'spec_helper'

describe LineServer::Chunk do 

	let(:file_name) { "#{Dir.pwd}/spec/fixtures/aesops_fables.txt" }
	let(:tempfile) { get_first_chunk }
	let(:file_size) {LineServer::FileProcessor::CHUNK_LIMIT}
	let(:file_lines) { get_file_lines }
	let(:second_tempfile) { get_second_chunk }

	describe "#get_line" do 
		it "will return a specified line from the chunk" do
			chunk = LineServer::Chunk.new(tempfile, 1, file_size ) 
			random_line = 1 + rand(file_size - 1)
			expect(chunk.get_line(random_line)).to eq(file_lines[random_line - 1])
		end

		it "should raise an error when getting a line not in its range" do
			chunk = LineServer::Chunk.new(tempfile, 1, file_size ) 
			expect {chunk.get_line(file_size + 1)}.to raise_error(RuntimeError)
		end

		it "should correctly get the line from a second chunk" do
			second_end_line = file_size * 2
			chunk = LineServer::Chunk.new(second_tempfile, file_size + 1, second_end_line) 
			random_line = file_size + rand(file_size)
			expect(chunk.get_line(random_line)).to eq(file_lines[random_line - 1])
		end
	end

	after(:each) do
    unlink_file(tempfile)
    unlink_file(second_tempfile)
	end

	def get_first_chunk
		stream = IO.sysopen file_name
		io = IO.new(stream)
		temp_file = get_file_chunk(io)
		io.close
		temp_file
	end

	def get_second_chunk
		stream = IO.sysopen file_name
		io = IO.new(stream)
		get_file_chunk(io)
		temp_file = get_file_chunk(io)
		io.close
		temp_file
	end

	def get_file_chunk(io)
		line_count = 1
		tempfile = Tempfile.new("test_chunk")
		begin
			tempfile.write(io.gets)
			line_count += 1
		end while line_count <= file_size
		tempfile.close
		tempfile
	end

	def get_file_lines
		IO.readlines(file_name)
	end

	def unlink_file(file)
		if file
			file.unlink
		end
	end

end