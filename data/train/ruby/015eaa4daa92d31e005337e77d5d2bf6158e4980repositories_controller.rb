class RepositoriesController < ApplicationController
  before_action :new_a_repository, only: [:new,:create]
  before_action :find_a_repository, only: [:show,:update,:destroy,:edit]

  def index
    @repositories = Repository.page(params[:page]).per(50)
  end

  def new
    @catalogs = Catalog.all
  end

  def create
    @repository.save_repository(params)
    @repository_log = RepositoryLog.new
    event = '知识库表中问题为:' + @repository.title + '的记录'
    @repository_log.save(current_user.username,'增加',event)
    if @repository.save
      redirect_to repositories_path
    else
      @catalogs = Catalog.all
      render :new
    end
  end

  def show
    @catalogs = Catalog.all
  end

  def update
    @repository.save_repository(params)
    redirect_to repositories_path
  end

  def destroy
    @repository.destroy
    @repository_log = RepositoryLog.new
    event = '知识库表中问题为:' + @repository.title + '的记录'
    @repository_log.save(current_user.username,'删除',event)
    redirect_to repositories_path
  end

  def edit
    @catalogs = Catalog.all
  end

  private
    def new_a_repository
      @repository = Repository.new
    end

    def find_a_repository
      @repository = Repository.find(params[:id])
    end
end
