class RepositoriesController < ApplicationController
  before_action :authenticate_person!
  before_action :set_repository, only: [:edit, :update, :destroy]

  # GET /repositories
  # GET /repositories.json
  def index
    repositories = current_person.github_client.repos + current_person.github_client.orgs.map { |o| o.rels[:repos].get.data }.flatten
    @repositories = repositories.group_by { |r| r.owner.login }
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    @repository = Repository.find_by(full_name: URI.decode(params[:id])) ||
      Repository.find_by(id: params[:id]) ||
      Repository.new(person: current_person, full_name: params[:id])
    @repository.save
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
  end

  # POST /repositories
  # POST /repositories.json
  def create
    full_name = params[:repository][:full_name]
    repository_params = current_person.github_client.repos.find {|r| r.full_name == full_name }
    @repository = Repository.new(
      person: current_person,
      ssh_url: repository_params.rels[:ssh].href,
      full_name: full_name,
      data: JSON.parse(repository_params.to_json)
    )

    respond_to do |format|
      if @repository.save
        format.html { redirect_to @repository, notice: 'Repository was successfully created.' }
        format.json { render json: @repository, status: :created, location: @repository }
      else
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repositories/1
  # PATCH/PUT /repositories/1.json
  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to @repository, notice: 'Repository was successfully updated.' }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.json
  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to repositories_url, notice: 'Repository was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repository
      @repository = Repository.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repository_params
      params.require(:repository).permit(:user_id, :name)
    end
end
