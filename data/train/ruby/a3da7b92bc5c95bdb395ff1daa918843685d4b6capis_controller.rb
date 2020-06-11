class ApisController < ApplicationController
	skip_before_filter :authenticate, only: [:index, :show, :mashups]

	def index
		@apis = Api.all
		@apis.sort! {|a, b| a.name.downcase <=> b.name.downcase}
	end

	def show
		@api = Api.find(params[:id])
	end

	def new
		@api = Api.new(requires_key: "yes")
	end

	def create
		new_api = Api.create(params[:api])
		redirect_to new_api
	end

	def edit
		@api = Api.find(params[:id])
	end

	def update
		found_api = Api.find(params[:id])
		found_api.update_attributes(params[:api])
		redirect_to found_api
	end

	def destroy
		Api.delete(params[:id])
		redirect_to apis_path
	end

	def mashups
		@api = Api.find(params[:id])
		@mashups = @api.mashups
	end

end
