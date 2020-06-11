class RepositoriesController < SecureController

	def index
		@repositories = Repository.all
		@repositories.each do |repo|
			repo.status = Net::Ping::TCP.new(repo.url.gsub("http://","").gsub("/",""), 'http').ping?
			repo.save
		end
	end

	def show
		@repository = Repository.find(params[:id])
	end

	def new
		@repository_group = RepositoryGroup.find(params[:repository_group_id])
		@repository = Repository.new
	end

	def create
		@repository_group = RepositoryGroup.find(params[:repository_group_id])
		@repository = Repository.new(params[:repository])
		if @repository = @repository_group.repositories.create(params[:repository])
			flash[:success] = "Repository #{@repository.name} was successfully created"
		else
		  flash[:error] = "Repository #{@repository.name} can\'t be created"
		end
		redirect_to repository_group_path(@repository_group)
	end

	def edit
		@repository_group = RepositoryGroup.find(params[:repository_group_id])
		@repository = Repository.find(params[:id])
	end

	def update
		@repository = Repository.find(params[:id])
		if @repository.update_attributes(params[:repository])
			flash[:success] = "Repository #{@repository.name} was successfully updated"
		else
		    flash[:error] = "Repository #{@repository.name} can\'t be updated"
		end
		redirect_to repository_group_path(@repository.repository_group.id)
	end

	def destroy
		@repository = Repository.find(params[:id])
		if @repository.destroy
			flash[:success] = "Repository #{@repository.name} was successfully deleted"
		else
			flash[:error] = "Repository #{@repository.name} can't be deleted"
		end
		redirect_to repository_group_path(@repository.repository_group.id)
	end

	def multiple_actions
		if params.include?("repo_ids")
			deleted_repos = []
			@checked_repo_ids = params[:repo_ids].map(&:to_i)
			@checked_repo_ids.each do |r|
				repo = Repository.find(r)
				deleted_repos << repo.name if repo.destroy
			end
			unless deleted_repos.empty?
				flash[:success] = "Repository: \n#{deleted_repos.join("\n")}\n were successfully deleted."
			end
		end
		flash[:error] = "No repositories checked !" unless params.include?("repo_ids")
		redirect_to :back
	end

end