class RepositoryCommentsController < ApplicationController
	before_filter :authenticate_user!, except: [:index]
	respond_to :json
	
	# GET /comments.json
  def index
    @repository_comments = RepositoryComment.where(repository_id: params[:repo_id])
		comment_ids = []
		@repository_comments.each do |res|
			comment_ids << res.comment_id
		end
		@comments = Comment.where(id: comment_ids)
		render json: @comments
  end
	
	# GET /comments/1.json
  def show
		@repository_comment = RepositoryComment.find(params[:id])
		
		respond_with(@repository_comment)
  end
	
	
	#creates a new comment with the given message
	#
  # POST /repository_comments.json
  def create
		@comment = Comment.new()
		@comment.comment = params[:message] 
		@comment.user = current_user
		#@comment.save
		
		@repository = Repository.find(params[:repo_id])
		@repository.comments << @comment
		@repository.save
		
		respond_with(@comment)
  end
	
	private
    def set_repository_comment
      @comment = Comment.find(params[:id])
    end

    def repository_comment_params
			params.require(:comment).permit(:repository_id, :created_at)
    end
end
