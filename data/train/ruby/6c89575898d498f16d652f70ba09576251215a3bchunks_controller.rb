module Chunks::Admin
  class ChunksController < AdminController  
    def new
      render_for_page(params[:type].to_class.new)
    end
    
    def include
      render_for_page(Chunks::Chunk.find(params[:id]))
    end
    
    def preview
      chunk_params = params[:chunk] if params[:chunk]
      chunk_params = params[:shared_chunk][:chunk_attributes] if params[:shared_chunk]
      chunk_params = params[:page][:chunks_attributes].first.last if params[:page]
      @chunk = chunk_params[:id] ? Chunks::Chunk.find(chunk_params[:id]) : chunk_params[:type].to_class.new
      @chunk.usage_context = Chunks::ChunkUsage.new
      @chunk.attributes = chunk_params.except(:type, :id, :_destroy)      
      render layout: "chunks/admin/chunk_preview", nothing: true
    end
    
    def share
      chunk = Chunks::Chunk.find(params[:id])
      if chunk.share(params[:name]).valid?
        render text: "Chunk has been shared."
      else
        render status: :error, json: chunk.shared_chunk.errors
      end
    end
    
    
    private
    
    def render_for_page(chunk)
      @chunk = chunk
      @page = Chunks::Page.find(params[:page_id])
      @page.add_chunk(@chunk, params[:container_key])
      @chunk.errors.clear
      render action: "show", layout: false
    end
  end
end