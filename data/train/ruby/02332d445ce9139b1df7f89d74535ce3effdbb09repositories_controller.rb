require 'vacuum'

class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end

  def new
    @repository = Repository.new
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def create
    register_repository = RegisterRepository.call(register_repository_params)

    if register_repository.success?
      redirect_to root_path, notice: "Loots on #{register_repository.repository.link} in progress!"
    else
      redirect_to new_repository_path, alert: "Something went wrong: #{register_repository.message}"
    end
  end

  private

  def register_repository_params
    params.require(:repository).permit(:link).merge({
      user_id: current_user.id
    })
  end
end
