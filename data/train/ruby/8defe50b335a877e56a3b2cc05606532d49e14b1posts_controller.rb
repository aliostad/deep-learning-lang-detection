class Manage::PostsController < Manage::ApplicationController
  before_filter :get_post, :only => [:show,:edit,:update,:destroy]
  before_filter :get_postable, :only => [:new,:edit,:create,:update,:destroy]
  def index
    if params[:postable_type] and params[:postable_id]
      @postable = params[:postable_type].constantize.find(params[:postable_id])
      @posts = @postable.posts
    else
      @posts = Post.find(:all)
    end
  end

  # GET /manage_posts/1
  # GET /manage_posts/1.xml
  def show
  end

  # GET /manage_posts/new
  # GET /manage_posts/new.xml
  def new
    @post = Post.new
    @postable.posts << @post
  end

  # GET /manage_posts/1/edit
  def edit
  end

  # POST /manage_posts
  # POST /manage_posts.xml
  def create
    @post = Post.new(params[:post])
    if @post.save
      render :template => 'manage/posts/index' and return
    else
      render :template => 'manage/posts/new' and return
    end
  end

  # PUT /manage_posts/1
  # PUT /manage_posts/1.xml
  def update
    if params.has_key? :image and params[:image] == 'delete'
      @post.image = nil
    end
    if @post.update_attributes(params[:post])
      render :template => 'manage/posts/index' and return
    else
      render :template => 'manage/posts/edit' and return
    end
  end

  # DELETE /manage_posts/1
  # DELETE /manage_posts/1.xml
  def destroy
    @post.destroy
    render :template => 'manage/posts/index' and return
  end

  private
  def get_post
    @post = Post.find(params[:id])
  end
  def get_postable
    @postable = params[:post][:postable_type].constantize.find(params[:post][:postable_id])
    @posts = @postable.posts
  end
end
