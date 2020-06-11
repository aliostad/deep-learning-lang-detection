class ChunksController < ApplicationController

  def index
      @chunks = Chunk.all
    
      respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chunks }
    end
  end

  def show
    @chunk = Chunk.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chunk }
    end
  end

  def new
    @chunk = Chunk.new
    @chunk.clinician = current_clinician
    @chunk.date = Date.parse(current_date)
    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.json { render json: @chunk }
    end
  end

  def edit
    @chunk = Chunk.find(params[:id])
  end

  def create
    @chunk = Chunk.new(params[:chunk])
    @chunk.clinician = current_clinician
    @chunk.date = current_date
    respond_to do |format|
      if @chunk.save
        format.html { redirect_to clinician_path(current_clinician) }
        format.js
        format.json { render json: @chunk, status: :created, location: @chunk }
      else
        format.html { render 'new' }
        format.js   { render 'error'}
        format.json { render json: @chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @chunk = Chunk.find(params[:id])

    respond_to do |format|
      if @chunk.update_attributes(params[:chunk])
        format.html { redirect_to clinician_path(current_clinician) }
        format.js
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js   { render 'error'}
        format.json { render json: @chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chunk = Chunk.find(params[:id])
    @chunk.destroy

    respond_to do |format|
      format.html { redirect_to clinician_path(current_clinician) }
      format.js
    end
  end
end
