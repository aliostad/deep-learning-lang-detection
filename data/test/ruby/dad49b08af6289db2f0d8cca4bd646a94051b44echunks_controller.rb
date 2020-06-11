class ChunksController < ApplicationController

	before_filter :authenticate_user!


	# GET /chunks
	# GET /chunks.json


	def show
		@context = context
		@chunk = context.chunks.find(params[:id])
		respond_to do |format|
			format.html { render_check_template }
			format.json { render json: @chunk }
		end
	end

	def new
		@context = context
		@chunk = @context.chunks.new

		respond_to do |format|
			format.html { render_check_template }
			format.json { render json: @chunk }
		end
	end

	def edit
		@context = context
		@chunk = @context.chunks.find(params[:id])
		render_check_template
	end

	def create
		@context = context
		@chunk = @context.chunks.new(chunk_params)

		respond_to do |format|
			if @chunk.save
				format.html { redirect_to context_url(context), notice: I18n.t('views.chunk.flash_messages.book_was_successfully_created') }
				format.json { render json: @chunk, status: :created, location: @chunk }
			else
				format.html { render action: "new" }
				format.json { render json: @chunk.errors, status: :unprocessable_entity }
			end
		end

	end

	def update
		@context = context
		@chunk = @context.chunks.find(chunk_params)
		if @chunk.update_attributes(chunk_params)
			redirect_to context_url(context), notice: I18n.t('views.chunk.flash_messages.book_was_successfully_updated')
		end
	end

	def destroy
		@chunk = Chunk.find(chunk_params)
		@chunk.destroy

		respond_to do |format|
			format.html { redirect_to context_url(context) }
			format.json { head :no_content }
		end
	end

	def chunks_versions
		@versions = @context.chunks.versions
	end

	private
	def chunk_params
		params.require(:chunk).permit!
	end

	private
	def context
		if params[:chapter_id]
			id = params[:chapter_id]
			Chapter.find(params[:chapter_id])
		else
			params[:book_id]
			id = params[:book_id]
			Book.find(params[:book_id])
		end
	end

	private
	def context_url(context)
		if Book === context
			book_path(context)
		else
			chapter_path(context)
		end
	end

end
