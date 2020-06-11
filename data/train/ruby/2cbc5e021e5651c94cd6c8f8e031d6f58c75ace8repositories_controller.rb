# coding: utf-8
require "nokogiri"
require "pp"

class RepositoriesController < ApplicationController
  before_filter :signin_check, :only => ['new','delete','edit','update','clone_edit','clone', 'favorite']
  # rescue_from Exception, :with => :goto_error_page

  # GET /repositories
  def index
    begin
      # sidebar用
      @repository_list = Repository.where("is_deleted = ?", 0).group('title').order('title').count

      # メイン部分の情報
      @repositories = Repository.where("is_deleted = ?", 0).order('title asc, name asc')
      @repositories = @repositories.page(params[:page])
      
      # オプションパラメータ
      if params[:title]
        @title = params[:title]
        @repositories = @repositories.where("title like ?", "%#{@title}%")
      end
      
      if params[:owner]
        @owner = Owner.find(params[:owner]).screen_name
        @repositories = @repositories.where("owner_id = ?", params[:owner])
      end
    rescue
      goto_error_page
    end
  end

  # GET /repositories/1
  def show
    begin
      @repository = Repository.find(params[:id])
      # 削除チェック
      raise if @repository.is_deleted == 1
    rescue
      goto_error_page("このチャートは削除されたか存在しません。")
    end
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
    begin
      @repository = Repository.find(params[:id])

      # 本人確認
      onwer_check(@repository.owner_id)
    rescue
      goto_error_page
    end
  end

  # GET /repositories/1/clone_edit
  def clone_edit
    begin
      @repository = Repository.find(params[:id])
    rescue
      goto_error_page
    end
  end

  # GET /repositories/1/clone
  def clone
    begin
      base_repository = Repository.find(params[:id])
      base_repository.clone_count += 1 # 再起的にカウントする??

      @repository = Repository.new
      @repository.owner_id = user_info.id
      @repository.base_repo_id = base_repository.id
      @repository.name = params[:repository][:name]
      @repository.title = base_repository.title
      @repository.max_number = base_repository.max_number

      respond_to do |format|
        if @repository.save && base_repository.save

          # documentsをコピーする
          base_repository.documents.each do |base_doc|
            doc = Document.new
            doc.number = base_doc.number
            doc.name = base_doc.name
            doc.text = base_doc.text
            doc.repository_id = @repository.id
            doc.save
          end

          # リポジトリのクローンを作成する
          git_clone(base_repository.owner_id, base_repository.id, @repository.owner_id, @repository.id)

          format.html { redirect_to @repository, notice: '新しいチャート（コピー）を作成しました' }
        else
          @repository = base_repository
          @repository.errors.add :name, :empty
          format.html { render action: "clone_edit" }
        end
      end
    rescue
      goto_error_page
    end
  end

  # POST /repositories
  def create
    begin
      @repository = Repository.new(params[:repository])
      @repository.owner_id = user_info.id

      respond_to do |format|
        if @repository.save
          # リポジトリを作成する
          git_init(@repository.owner_id, @repository.id)

          format.html { redirect_to @repository, notice: '新しいチャートを作成しました' }
        else
          format.html { render action: "new" }
        end
      end
    rescue
      goto_error_page
    end
  end

  # PUT /repositories/1
  def update
    begin
      @repository = Repository.find(params[:id])

      # 本人確認
      onwer_check(@repository.owner_id)

      respond_to do |format|
        if @repository.update_attributes(params[:repository])
          format.html { redirect_to @repository, notice: 'チャートの情報を更新しました' }
        else
          format.html { render action: "edit" }
        end
      end
    rescue => ex
      logger.debug(ex)
      goto_error_page()
    end
  end

  # DELETE /repositories/1
  def destroy
    begin
      @repository = Repository.find(params[:id])

      # 本人確認
      onwer_check(@repository.owner_id)

      # repository自体を消してしまうと、repository_treeを追えなくなってしまうのでステータスの変更にする
      # @repository.destroy
      @repository.is_deleted = true

      respond_to do |format|
        if @repository.save
          format.html { redirect_to repositories_url, notice: 'チャートを削除しました'  }
        else
          format.html { render action: "index" }
        end
      end
    rescue
      goto_error_page
    end
  end

  def favorite
    begin
      @favorite = Favorite.where("owner_id = ? and repository_id = ?", user_info.id, params[:id]).first

      # レコードがある場合削除
      if @favorite
        @favorite.destroy
      # 無ければ登録
      else
        @favorite = Favorite.new
        @favorite.owner_id = user_info.id
        @favorite.repository_id = params[:id]
        @favorite.repository_owner_id = Repository.find(params[:id]).owner_id
        @favorite.save
      end

      redirect_to Repository.find(params[:id])
    rescue
      goto_error_page
    end
  end

  private

  def git_init(owner_id, repository_id)
    working_dir = "#{ENV['GIT_REPOSITORIES_PATH']}/#{owner_id}/#{repository_id}"
    g = Git.init(working_dir)
  end

  def git_clone(base_owner_id, base_repository_id, clone_owner_id, clone_repository_id)
    base_dir = "#{ENV['GIT_REPOSITORIES_PATH']}/#{base_owner_id}/#{base_repository_id}"
    base_repo = Git.open(base_dir)

    clone_dir = "#{ENV['GIT_REPOSITORIES_PATH']}/#{clone_owner_id}/"
    g = Git.clone(base_repo.repo, clone_repository_id.to_s, :path => clone_dir)
  end
end
