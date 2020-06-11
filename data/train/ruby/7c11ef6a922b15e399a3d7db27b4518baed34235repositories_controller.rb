class Api::RepositoriesController < ApiController
  # Find the current repository when invoking show, update or destroy
  before_action :find_repository, only: [:show,:update,:destroy]

  def index
    render json: Repository.where(managed_by: authenticated_user.login), each_serializer: RepositorySummarySerializer
  end

  def show
    if not @repository
      render json: { :error => "Repository not found" }, status: 404
    end

    # TODO: Store this as metadata in the database.
    github_adapter = Github.new oauth_token: access_token
    pull_requests = github_adapter.pull_requests.list(@repository.owner,@repository.name).count

    @repository.pull_requests = pull_requests

    render json: @repository, serializer: RepositorySerializer
  end

  def create

  end

  def update
    if not @repository
      render json: { :error => "Repository not found" }, status: 404
    end

    @repository.update(params.require(:repository).permit(:license_text))

    render json: @repository, serializer: RepositorySerializer
  end

  def destroy
    if not @repository
      render json: { :error => "Repository not found" }, status: 404
    end

    Repository.destroy params[:id]

    head :no_content, status: :ok
  end

  def sign_license
    # Use a direct find operation instead of the find_repository method
    # The find_repository method ensures that we have management rights, but
    # you don't need those for repositories that you are signing a license for.
    @repository = Repository.find(params[:id])

    if not @repository
      render json: { :error => "Repository not found" }, status: 404
    end

    signature = Signature.new(params.require(:signature).permit(:name,:company,:email))
    signature.repository_id = @repository.id

    signature.save

    render json: signature, serializer: SignatureSerializer
  end

  private

  def find_repository
    # Find and assign the repository to the repository field,
    # unless the user is not managing the repository
    repository = Repository.find(params[:id])
    @repository = repository unless repository.managed_by != authenticated_user.login
  end
end
