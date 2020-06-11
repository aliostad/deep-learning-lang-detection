class ChunksController < ApplicationController
  # GET /chunks
  # GET /chunks.json

  before_filter :setupsimperium

  def setupsimperium
    require 'simperium'
    @auth = Simperium::Auth.new('proficiency-stitches-d7f', '1c3b994783a6430e9f6f595a1be93c38')
    @token = @auth.authorize('email1@address.com', 'password')
    @api = Simperium::Api.new('proficiency-stitches-d7f', @token)
  end    

  def index
    @chunks = Chunk.all

    @schunks = @api.chunk.index(:data=>true, :mark=>nil, :limit=>nil, :since=>nil)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chunks }
    end
  end

  # GET /chunks/1
  # GET /chunks/1.json
  def show
    @chunk = Chunk.find(params[:id])

    @schunk = @api.chunk.get(@chunk.label)

    @schunk.each_pair do |key, value|
        @key = key
        @value = value
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @chunk }
    end
  end

  # GET /chunks/new
  # GET /chunks/new.json
  def new
    @chunk = Chunk.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chunk }
    end
  end

  # GET /chunks/1/edit
  def edit
    @chunk = Chunk.find(params[:id])

    @schunk = @api.chunk.get(@chunk.label)

    @schunk.each_pair do |key, value|
        @key = key
        @value = value
    end

  end

  # POST /chunks
  # POST /chunks.json
  def create
    @chunk = Chunk.new(params[:chunk])

    @data = {@chunk.key => @chunk.value}

    @label = @api.chunk.new(@data)

    @chunk.label = @label

    respond_to do |format|
      if @chunk.save
        format.html { redirect_to @chunk, notice: 'Chunk was successfully created.' }
        format.json { render json: @chunk, status: :created, location: @chunk }
      else
        format.html { render action: "new" }
        format.json { render json: @chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /chunks/1
  # PUT /chunks/1.json
  def update
    @chunk = Chunk.find(params[:id])
    
    respond_to do |format|
      if @chunk.update_attributes(params[:chunk])

        #Rails chunk object updated, use this to update simperium. 
        @data = {@chunk.key => @chunk.value}
        @api.chunk.set(@chunk.label, @data)

        format.html { redirect_to @chunk, notice: (@newdata) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chunks/1
  # DELETE /chunks/1.json
  def destroy
    @chunk = Chunk.find(params[:id])

    @api.chunk.delete(@chunk.label)

    @chunk.destroy

    respond_to do |format|
      format.html { redirect_to chunks_url }
      format.json { head :no_content }
    end
  end
end
