class ChunksController < ApplicationController

  layout 'books_and_chunks'
  before_filter :authenticate_user!
  before_filter :find_book

=begin
  def index
    @book = Book.find(params[:book_id])
    @chunks = @book.chunks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @chunks }
    end
  end
=end

  def show
    @chunk = Chunk.find(params[:id])

    respond_to do |format|
      format.html { render_check_template }
      format.json { render json: @chunk }
    end
  end

  def new
    @chunk = Chunk.new

    respond_to do |format|
      format.html { render_check_template }
      format.json { render json: @chunk }
    end
  end

  def edit
    @chunk = Chunk.find(params[:id])
    render_check_template
  end

  def create
    @chunk = Chunk.new(params[:chunk])
    @chunk.book = @book

    respond_to do |format|
      if @chunk.save
        format.html { redirect_to @book, notice: I18n.t('views.chunk.flash_messages.book_was_successfully_created') }
        format.json { render json: @chunk, status: :created, location: @chunk }
      else
        format.html { render action: "new" }
        format.json { render json: @chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @chunk = Chunk.find(params[:id])

    respond_to do |format|
      if (@chunk.update_attributes(params[:chunk]))
        format.html { redirect_to @book, notice: I18n.t('views.chunk.flash_messages.book_was_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @chunk.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chunk = Chunk.find(params[:id])
    @chunk.destroy

    respond_to do |format|
      format.html { redirect_to @book }
      format.json { head :no_content }
    end
  end

  private
  def find_book
    @book = Book.find(params[:book_id])
  end

end
