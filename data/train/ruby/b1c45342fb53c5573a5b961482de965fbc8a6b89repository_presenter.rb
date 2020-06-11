require 'active_support/core_ext/module/delegation'

class RepositoryPresenter
  delegate :created_at,
           :description,
           :link,
           :owner,
           :pull_requests,
           :sorted_pull_requests,
           :title,
           to: :@repository

  def initialize(repository)
    @repository = repository
  end

  def descriptive_title
    "#{repository.owner}/#{repository.title} pull requests"
  end

  def sorted_pull_requests
    @sorted ||= pull_requests.sort { |a, b| b.created_at <=> a.created_at }
  end

  def presented_pull_requests
    @parsed ||= sorted_pull_requests.map do |request|
      PullRequestPresenter.new(request)
    end
  end

  private

  attr_reader :repository
end
