class ExternalRepositoriesController < ApplicationController

  def new
    @external_repository = ExternalRepository.new(blueprint_version_id: params[:blueprint_version_id])
  end

  def create
    @external_repository = ExternalRepository.new(external_repository_params)
    if @external_repository.save
      redirect_to ( url_for( @external_repository.blueprint_version ) + '#' + @external_repository.class.name.underscore + '_' + @external_repository.id.to_s )
    else
      render 'new'
    end
  end

  def show
    @external_repository = ExternalRepository.find(params[:id])
  end

  def edit
    @external_repository = ExternalRepository.find(params[:id])
  end

  def update
    @external_repository = ExternalRepository.find(params[:id])

    if @external_repository.update(external_repository_params)
      redirect_to ( url_for( @external_repository.blueprint_version ) + '#' + @external_repository.class.name.underscore + '_' + @external_repository.id.to_s )
    else
      render 'edit'
    end
  end

  def destroy
    @external_repository = ExternalRepository.find(params[:id])
    @external_repository.destroy
    redirect_to ( url_for( @external_repository.blueprint_version ) + '#' + @external_repository.class.name.pluralize.underscore )
  end

private

  def external_repository_params
    params.require(:external_repository).permit!
  end

end