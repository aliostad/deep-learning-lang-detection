require_relative 'document_splitter'
require_relative 'chunk_identifier'

class ChiselRunner
  attr_reader :doc_splitter, :chunk_id

  def initialize(document)
    @document = document
    @doc_splitter = DocumentSplitter.new(document)
  end

  
end

  # def format_chunk_to_html(identify)
  #   case identify
  #   when "paragraph"  then ParagraphRenderer.new(chunk)
  #   when "list"       then
  #   when "header"     then
  # end

  # def format_document_to_html
  #   split_pieces = doc_splitter.to_a

  #   chunk_id = ChunkIdentifier.new
  #   id_pieces = split_pieces.each do |piece| 
  #     chunk_id.identifier(piece)
  #   end

  #   if id_pieces == "header"

  # end



# private
  # def parse
  #   doc_splitter.to_a
  # end

  # def identify
  #   chunk_id = ChunkIdentifier.new
  #   parse.each_with_object({}) do |chunk, labeled_pieces| 
  #     labeled_pieces[chunk] = chunk_id.identifier(chunk) 
  #   end
  # end

