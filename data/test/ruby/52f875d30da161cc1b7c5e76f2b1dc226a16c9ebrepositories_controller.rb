class RepositoriesController < ApplicationController
	respond_to :html

	def index
		@repository = Repository.new
	end

	def show
		@repository = Repository.find(params[:id])
		respond_with @repository
	end

	def create
		@repository = Repository.where(repository_params).first_or_create
		# if it's not valid, show the error
		return render :index if !@repository.complete && !@repository.persisted?
		# perform analytics if it hasn't been completed
		RepositoryWorker.perform_async(@repository.id) if !@repository.complete && !Stats.processing(@repository.id)
		redirect_to @repository
	end

	private
	def repository_params
		# this is here because the only way to use first_or_create is to make sure the url is sanitized to find older urls
		#  based on this design anyway, changing how the url is stored would change it
		params[:repository][:url] = Repository.github(params[:repository][:url])
		params.require(:repository).permit(:url)
	end
end
