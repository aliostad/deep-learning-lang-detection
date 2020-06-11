module Manage
  class PostsController < Manage::ManageController
    respond_to :html
    
    expose( :blog )  { current_frame.blog }
    expose( :posts ) { blog.posts }
    expose( :post )

    def create
      flash[ :notice ] = "Post: #{ post.title } was successfully created." if post.save
      respond_with :manage, :blog, post, location: manage_blog_path
    end

    def update
      flash[ :notice ] = "Post: #{ post.title } was successfully updated." if post.update_attributes( params[ :post ] )
      respond_with :manage, :blog, post, location: manage_blog_path
    end
  end
end