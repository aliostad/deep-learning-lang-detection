class ChunksController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:event, :destroy]
  
  def create
  	@chunk = current_user.chunks.build(chunk_params)

    # needs fixing for other start statusses
    @chunk.status_id = 0

    if @chunk.save
      flash[:success] = "Chunk created!"
      redirect_to root_url
    else
      @todo_chunks = current_user.todo_chunks
      @recently_closed_chunks = current_user.recently_closed_chunks
      render 'static_pages/home'
    end
  end

  def destroy
    @chunk.destroy
    redirect_to root_url
  end

  def event
    # for now I just implement 0 (close) and 1 (undo)
    # for the full version we'll need the entire workflow mechanism and tables
    case params[:event_id]
    when "0"
      # close the status of the chunk  
      @chunk.status_id = 1
      @chunk.save
      flash[:success] = "Chunk done!"
    when "1"
      # undo closing the chunk  
      @chunk.status_id = 0
      @chunk.save
      flash[:success] = "Chunk opened again"
    else
      flash[:warning] = "Not implemented event "+params[:event_id]
    end
    redirect_to root_url
  end

  private

    def chunk_params
      params.require(:chunk).permit(:description)
    end

    def correct_user
      @chunk = current_user.chunks.find_by(id: params[:id])
      if @chunk.nil?
        flash[:warning] = "Wrong user"
        redirect_to root_url
      end
    end

end
