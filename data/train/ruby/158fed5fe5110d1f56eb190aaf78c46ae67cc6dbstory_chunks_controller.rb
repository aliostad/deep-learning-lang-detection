class StoryChunksController < ApplicationController

  #->Prelang (scaffolding:rails/scope_to_user)
  before_filter :require_user_signed_in, only: [:new, :edit, :create, :update, :destroy]

  before_action :set_story_chunk, only: [:show, :edit, :update, :destroy]

  # GET /story_chunks
  # GET /story_chunks.json
  def index
    @story_chunks = StoryChunk.all
  end

  # GET /story_chunks/1
  # GET /story_chunks/1.json
  def show
  end

  # GET /story_chunks/new
  def new
    @story_chunk = StoryChunk.new
  end

  # GET /story_chunks/1/edit
  def edit
  end

  # POST /story_chunks
  # POST /story_chunks.json
  def create
    @story_chunk = StoryChunk.new(story_chunk_params)
    @story_chunk.user = current_user

    respond_to do |format|
      if @story_chunk.save
        format.html { redirect_to @story_chunk, notice: 'Story chunk was successfully created.' }
        format.json { render :show, status: :created, location: @story_chunk }
      else
        format.html { render :new }
        format.json { render json: @story_chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /story_chunks/1
  # PATCH/PUT /story_chunks/1.json
  def update
    respond_to do |format|
      if @story_chunk.update(story_chunk_params)
        format.html { redirect_to @story_chunk, notice: 'Story chunk was successfully updated.' }
        format.json { render :show, status: :ok, location: @story_chunk }
      else
        format.html { render :edit }
        format.json { render json: @story_chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /story_chunks/1
  # DELETE /story_chunks/1.json
  def destroy
    @story_chunk.destroy
    respond_to do |format|
      format.html { redirect_to story_chunks_url, notice: 'Story chunk was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story_chunk
      @story_chunk = StoryChunk.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_chunk_params
      params.require(:story_chunk).permit(:user_id, :story_block_id, :published, :content, :chunkid)
    end
end
