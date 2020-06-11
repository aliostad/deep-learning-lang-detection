module Administration
  class ExternalRepositoriesController < ApplicationController
    before_action :set_external_repository, only: [:show, :syncronise]


    def index
      @external_repositories = Administration::ExternalRepository.all
    end

    def show
    end

    def syncronise
      @external_repository.sync_status = 'REQUESTED' unless @external_repository.sync_status == 'NEW'
      @external_repository.sync_date = DateTime.now.to_s
      @external_repository.save
      Resque.enqueue("SyncExtRepo#{@external_repository.sync_method}".constantize,@external_repository.id)
      redirect_to @external_repository, notice: t('administration.external_repositories.flashmessage.synchronizing')
    end

    def set_external_repository
      @external_repository = ExternalRepository[URI.unescape(params[:id])]
    end
  end
end
