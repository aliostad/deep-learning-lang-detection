class SecretChunkWallsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_secret_chunk_wall, only: [:show, :edit, :update, :destroy]

  def index
    @secret_chunk_walls = current_user.secret_chunk_walls.order(updated_at: :desc)
  end

  def show
    @secret_chunks = @secret_chunk_wall.secret_chunks.all
    @secret_chunk = @secret_chunk_wall.secret_chunks.build
  end

  def new
    @secret_chunk_wall = SecretChunkWall.new
  end

  def edit
  end

  def create
    @secret_chunk_wall = SecretChunkWall.new(secret_chunk_wall_params)
    @secret_chunk_wall.user = current_user
    if @secret_chunk_wall.save
      redirect_to secret_chunk_wall_path(id: @secret_chunk_wall.uuid), notice: 'Secret chunk wall was successfully created.'
    else
      render :new
    end
  end

  def update
    if @secret_chunk_wall.update(secret_chunk_wall_params)
      redirect_to secret_chunk_wall_path(id: @secret_chunk_wall.uuid), notice: 'Secret chunk wall was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @secret_chunk_wall.destroy
    redirect_to secret_chunk_walls_url, notice: 'Secret chunk wall was successfully destroyed.'
  end

  private
    def set_secret_chunk_wall
      @secret_chunk_wall = SecretChunkWall.find_by(uuid: params[:id])
    end

    def secret_chunk_wall_params
      params.require(:secret_chunk_wall).permit(:title, :user_id)
    end
end
