class AdminController < ApplicationController
  def index
   
  end
  
  def manage_user
  end
  
  def manage_post
    session[:manage_type] = 'topic'
    redirect_to :controller => "manage_message"
  end

  def manage_blog
    session[:manage_type] = 'blog'
    redirect_to :controller => "manage_message"
  end

  def manage_message
    session[:manage_type] = 'message'
    redirect_to :controller => "manage_message"
  end
  
  def manage_news
    session[:manage_type] = 'news'
    session[:message_type] = 'news'
    redirect_to :controller => "manage_message"
  end
  
end
