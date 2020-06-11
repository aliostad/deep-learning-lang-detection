require 'spec_helper'

describe LineServer::ChunkedFile do 

	let(:chunked_file) { LineServer::ChunkedFile.instance }
	let(:chunk_size) { LineServer::FileProcessor::CHUNK_LIMIT }
	let(:chunk_freq) { 20 }

	describe "#search_chunks" do 
		it "will return the chunk that contains the specified line" do
			add_chunks
			search_results = chunked_file.search_chunks(657)
			expect(search_results.contains_line?(657)).to eq(true)
		end
	end

	describe "line_count" do 
		it "will return the total size of the chunked file" do
			add_chunks
			expect(chunked_file.line_count).to eq(chunk_freq * chunk_size)
		end
	end

	after(:each) do
    	chunked_file.delete_chunks
	end

	def add_chunks
		line_number = 0
		(1..chunk_freq).each do
			line_number += 1
			chunk = LineServer::Chunk.new(nil, line_number, line_number += (chunk_size - 1))
			chunked_file.add_chunk(chunk)
		end
	end

end