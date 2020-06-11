class SecretChunksController < ApplicationController
  before_action :set_secret_chunk, only: [:edit, :update, :destroy]

  def new
    @secret_chunk = SecretChunk.new
  end

  def edit
  end

  def create
    secret_chunk_wall = SecretChunkWall.find_by(uuid: params[:secret_chunk_wall_id])
    @secret_chunk = secret_chunk_wall.secret_chunks.build(secret_chunk_params)
    @secret_chunk.user = current_user

    if @secret_chunk.save
      redirect_to secret_chunk_wall_path(id: secret_chunk_wall.uuid), notice: 'Secret chunk was successfully created.'
    else
      redirect_to secret_chunk_wall_path(id: secret_chunk_wall.uuid), notice: 'Content cannot be empty!'
    end
  end

  def update
    if @secret_chunk.update(secret_chunk_params)
      redirect_to secret_chunk_wall_path(id: @secret_chunk.secret_chunk_wall.uuid), notice: 'Secret chunk was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @secret_chunk.destroy
    redirect_to secret_chunk_wall_path(id: @secret_chunk.secret_chunk_wall.uuid), notice: 'Secret chunk was successfully destroyed.'
  end

  private
    def set_secret_chunk
      @secret_chunk = SecretChunk.find(params[:id])
    end

    def secret_chunk_params
      params.require(:secret_chunk).permit(:user_id, :chunk_wall_id, :content)
    end
end
