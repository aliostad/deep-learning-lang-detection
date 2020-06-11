class ChunkWallsController < ApplicationController
  before_action :set_chunk_wall, only: [:show, :update]

  def index
    @chunk_walls = ChunkWall.all.order(updated_at: :desc)
  end

  def show
    @chunks = @chunk_wall.chunks.all
  end

  def edit
    @chunk_wall = current_user.chunk_wall
  end

  def update
    @chunk_wall.user = current_user
    if @chunk_wall.update(chunk_wall_params)
      redirect_to @chunk_wall, notice: 'Chunk wall was successfully updated.'
    else
      render :edit
    end
  end

  private
    def set_chunk_wall
      @chunk_wall = ChunkWall.find(params[:id])
    end

    def chunk_wall_params
      params.require(:chunk_wall).permit(:title)
    end
end
