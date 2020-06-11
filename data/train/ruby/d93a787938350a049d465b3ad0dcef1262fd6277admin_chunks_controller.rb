class AdminChunksController < ApplicationController
  # GET /admin_chunks
  # GET /admin_chunks.json
  def index
    @admin_chunks = AdminChunk.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @admin_chunks }
    end
  end

  # GET /admin_chunks/1
  # GET /admin_chunks/1.json
  def show
    @admin_chunk = AdminChunk.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @admin_chunk }
    end
  end

  # GET /admin_chunks/new
  # GET /admin_chunks/new.json
  def new
    @admin_chunk = AdminChunk.new
    @admin_chunk.clinician = current_clinician
    @admin_chunk.date = current_date
    
    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @admin_chunk }
    end
  end

  # GET /admin_chunks/1/edit
  def edit
    @admin_chunk = AdminChunk.find(params[:id])
  end

  # POST /admin_chunks
  # POST /admin_chunks.json
  def create
    @admin_chunk = AdminChunk.new(params[:admin_chunk])
    @admin_chunk.clinician = current_clinician
    @admin_chunk.date = current_date

    respond_to do |format|
      if @admin_chunk.save
        format.html { redirect_to clinician_path(current_clinician) }
        format.js
        format.json { render json: @admin_chunk, status: :created, location: @admin_chunk }
      else
        format.html { render action: "new" }
        format.js   { render 'error'}
        format.json { render json: @admin_chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin_chunks/1
  # PUT /admin_chunks/1.json
  def update
    @admin_chunk = AdminChunk.find(params[:id])

    respond_to do |format|
      if @admin_chunk.update_attributes(params[:admin_chunk])
        format.html { redirect_to clinician_path(current_clinician) }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js   { render 'error'}
        format.json { render json: @admin_chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_chunks/1
  # DELETE /admin_chunks/1.json
  def destroy
    @admin_chunk = AdminChunk.find(params[:id])
    @admin_chunk.destroy

    respond_to do |format|
      format.html { redirect_to admin_chunks_url }
      format.js
      format.json { head :no_content }
    end
  end
end
