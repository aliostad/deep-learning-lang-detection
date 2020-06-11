require 'will_paginate/array'

class RepositoriesController < ApplicationController
  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(params[:repository])

    if @repository.save
      redirect_to @repository, :notice => "Repository Created"
    else
      render :new
    end
  end

  def index
    @repositories = Repository.all
  end

  def show
    @repository = Repository.find(params[:id])
    @repository.ensure_repository_exists

    if @repository.has_local_clone?
      page = params[:page] ? params[:page] : 1
      @commits = @repository.commits(page.to_i - 1)
      @commit_pagination = WillPaginate::Collection.new(page, 10, @repository.total_commits)
    end
  end
end
