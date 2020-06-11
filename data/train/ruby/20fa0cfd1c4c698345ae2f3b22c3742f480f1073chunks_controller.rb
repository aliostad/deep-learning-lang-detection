class ChunksController < ApplicationController
  layout 'books_and_chunks'
  before_filter :authenticate_user!
  before_filter :find_book

  # GET /chunks
  # GET /chunks.json
  def index
    @chunks = Chunk.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chunks }
    end
  end

  # GET /chunks/1
  # GET /chunks/1.json
  def show
    @chunk = Chunk.find(params[:id])

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

    render_check_template
  end

  # POST /chunks
  # POST /chunks.json
  def create
    @chunk = Chunk.new(params[:chunk])
    @chunk.book = @book

    respond_to do |format|
      if @chunk.save
        format.html { redirect_to @book, notice: 'Chunk was successfully created.' }
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
        format.html { redirect_to @book, notice: 'Chunk was successfully updated.' }
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
    @chunk.destroy

    respond_to do |format|
      format.html { redirect_to @book }
      format.json { head :no_content }
    end
  end

  # Das richtige Buch zuordnen
  private
  def find_book
    @book = Book.find(params[:book_id])
  end
end
