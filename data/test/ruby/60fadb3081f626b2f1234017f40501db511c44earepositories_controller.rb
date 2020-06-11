class RepositoriesController < ApplicationController
  respond_to :json

  # GET /repositories/1.json
  def show
    @repository = Repository.find_by_id(params[:id])

    if @repository.nil?
      respond_with({}, status: :not_found)
    else
      respond_with(@repository, status: 200, location: @repository)
    end
  end

  # POST /repositories.json
  def create
    @repository = Repository.new(:url => params[:url].to_s, :tool => params[:tool])

    if @repository.save
      respond_with(@repository, status: :created, location: @repository)
    else
      respond_with(@repository.errors, status: :unprocessable_entity)
    end
  end

end
