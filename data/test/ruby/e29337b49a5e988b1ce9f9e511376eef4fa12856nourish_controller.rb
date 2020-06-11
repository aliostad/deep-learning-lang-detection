class NourishController < ApplicationController
  def index
    @cm = Cm.all
  	@manage_nourishes = ManageNourish.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1)
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"	
  end

  def restaurants_and_cafes	
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def recipes
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end

  def nutrition
    @cm = Cm.all
    @manage_magazines = Magazine.order('updated_at DESC').limit(1).all
    @subscriber = Subscriber.new
    @manage_articles = ManageArticle.order('updated_at DESC').limit(4).all
  	render :layout => "category"
  end
end
