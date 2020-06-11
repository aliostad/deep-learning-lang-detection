class GlowController < ApplicationController
  def index
    @cm = Cm.all
  	@manage_glows = ManageGlow.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def reviews
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def haircare
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def skincare
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end
end
