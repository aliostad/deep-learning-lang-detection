class RetreatController < ApplicationController
  def index
    @cm = Cm.all
  	@manage_retreats = ManageRetreat.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def international
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def local
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end
end
