require 'save_page_commands/create_page'
require 'save_page_commands/update_chunk'
require 'save_page_commands/add_chunk'

module SavePageCommands
  class << self

    def detect(params)
      return update_page(params) if page_exist?(params[:gpid])
      create_page(params)
    end

    def create_page(params)
      CreatePage.new(params[:gpid], params[:gcid], params[:content])
    end

    def update_page(params)
      return UpdateChunk.new(params[:gcid], params[:content]) if chunk_exist?(params[:gcid])
      AddChunk.new(params[:gpid], params[:gcid], params[:content])
    end

    private

      def page_exist?(gpid)
        Page.find_by_gpid(gpid)
      end

      def chunk_exist?(gcid)
        Chunk.find_by_gcid(gcid)
      end
  end
end
