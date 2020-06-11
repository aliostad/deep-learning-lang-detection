require 'spec_helper'
require 'rails_helper'

describe ResumableUpload::ChunksController, type: :controller do
  routes { ResumableUpload::Engine.routes }

  describe "GET 'show'" do

    it "returns 404 if chunk does not exist" do
      get 'show', resumableIdentifier: "error", resumableChunkNumber: "error"
      expect(response.code).to eq "404"
    end

    it "returns 200 if chunk exists" do
      FogStorage.new.create_file("spec_chunk_chunks/0", "derp")
      get 'show', resumableIdentifier: "spec_chunk", resumableChunkNumber: "0"
      expect(response.code).to eq "200"
    end

  end

  describe "POST 'create'" do

    it "concatenates a single chunk onto the chunk stack" do
      expect_any_instance_of(FogStorage).to receive(:create_file).with("spec_chunk_chunks/1", "some stuff")

      mock_file = mock_uploaded_file("file", "some stuff")
      post 'create', resumableIdentifier: "spec_chunk",
        resumableChunkNumber: "1", resumableChunkSize: "5", resumableCurrentChunkSize: "5", resumableTotalSize: "100", resumableTotalChunks: "1",
        file: mock_file

      expect(response.code).to eq "200"
    end

    it "completes file" do
      resumable_file_name = "spec_chunk"

      (1..5).each do |i|
        mock_file = mock_uploaded_file("file", "Part #{i}\n")

        post 'create', resumableIdentifier: resumable_file_name,
          resumableChunkNumber: i, resumableChunkSize: "5", resumableCurrentChunkSize: "5", resumableTotalSize: "25", resumableTotalChunks: "5", joinChunks: "1",
          file: mock_file
      end

      file = FogStorage.new.find_file(resumable_file_name)

      expect(file).to_not eq(nil)
      expect(file.body).to eq("Part 1\nPart 2\nPart 3\nPart 4\nPart 5\n")

      (1..5).each do |i|
        chunk = StoredChunk.find(resumable_file_name, i)
        expect(chunk).to eq(nil)
      end
    end

    it "doesn't complete file if param is not specified" do
      resumable_file_name = "spec_chunk"

      (1..5).each do |i|
        mock_file = mock_uploaded_file("file", "Part #{i}\n")

        post 'create', resumableIdentifier: resumable_file_name,
          resumableChunkNumber: i, resumableChunkSize: "5", resumableCurrentChunkSize: "5", resumableTotalSize: "25", resumableTotalChunks: "5",
          file: mock_file
      end

      file = FogStorage.new.find_file(resumable_file_name)
      expect(file).to eq(nil)

      (1..5).each do |i|
        chunk = StoredChunk.find(resumable_file_name, i)
        expect(chunk).to_not eq(nil)
      end
    end

  end

end
