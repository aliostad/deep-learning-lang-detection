class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :graphs]

  def index
    @repositories = Repository
                    .with_stats(:score, :commit_count, :additions, :deletions)
                    .order(score: :desc).run
  end

  def show
    @coders = Coder.only_with_stats(:score, :commit_count, :additions,
                                    :deletions)
              .where(repository: @repository).order(score: :desc).run
  end

  def graphs
    @chart = BurndownChart.new(@repository.issues).timeline
  end

  private

  def set_repository
    @repository = Repository.friendly.find(params[:id])
  end
end
