class ChunksController < ApplicationController
  before_action :set_chunk, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @chunk = Chunk.new
  end

  def edit
  end

  def create
    @chunk = Chunk.new(chunk_params)
    @chunk.user_id = current_user.id
    @chunk.chunk_wall_id = current_user.chunk_wall.id

    if @chunk.save
      redirect_to @chunk, notice: 'Chunk was successfully created.'
    else
      render :new
    end
  end

  def update
    if @chunk.update(chunk_params)
      redirect_to @chunk, notice: 'Chunk was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @chunk.destroy
    redirect_to chunk_wall_path(current_user.chunk_wall), notice: 'Chunk was successfully destroyed.'
  end

  private
    def set_chunk
      @chunk = Chunk.find(params[:id])
    end

    def chunk_params
      params.require(:chunk).permit(:user_id, :chunk_wall_id, :content)
    end
end
