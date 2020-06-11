module Chunks::Admin
  class SharedChunksController < AdminController 
    def index
      @shared_chunks = Chunks::SharedChunk.order(:name)
    end
    
    def edit
      @shared_chunk = Chunks::SharedChunk.find(params[:id])
    end
    
    def update
      @shared_chunk = Chunks::SharedChunk.find(params[:id])
      if @shared_chunk.update_attributes(params[:shared_chunk])
        redirect_to admin_shared_chunks_path
      else
        render status: :error, action: "edit"
      end
    end
    
    def destroy
      Chunks::SharedChunk.find(params[:id]).unshare
      redirect_to admin_shared_chunks_path
    end
  end
end