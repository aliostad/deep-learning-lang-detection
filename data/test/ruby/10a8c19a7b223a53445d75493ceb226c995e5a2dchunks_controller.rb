class ChunksController < ApplicationController
	before_action :signed_in_user, only: [:create, :delete, :action]

	def index
	end

	def create
		@chunk = current_user.chunks.build(chunk_params)
		
		# XXX fix this to obtrain the correct default value for a new chunk
		@chunk.chunk_status_id = 0
		
		if @chunk.save
			flash[:success] = "Chunk posted!"
			redirect_to @current_user
		else
			render 'static_pages/home'
		end
	end

	def destroy
		# set status of the chunk to deleted
		# create an undo link
		flash[:warning] = "Placeholder message: Chunk not yet deleted! click to undo"

		# redirect to the chunk list
		redirect_to root_url
	end

	def action
		# determine what action to perform

		# create a chunk_status_log entry with the old, new status and start and endtime

		# update the status of the chunk	
		flash[:success] = "Perform " + params['action_id'] + " on chunk " + params['id']

		# redirect to the chunk list
		redirect_to @current_user
	end

	def undo
	end

	private
		def chunk_params
			params.require(:chunk).permit(:short_desc)
		end
end