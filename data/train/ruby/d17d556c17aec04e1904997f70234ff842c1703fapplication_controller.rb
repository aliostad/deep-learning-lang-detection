# -*- coding: utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale, :set_context

  def set_context
    ['header_phone','social_buttons','index_promo','index_title','right_contacts','right_important','team_header','team_footer'].each do |var_name|
      chunk = Chunk.find_by_code(var_name)
      if chunk
        chunk = chunk.content.html_safe
      else
        chunk = ''
      end
      self.instance_variable_set('@' + var_name, chunk)
    end
    @menu = Page.where("menu=True")
    @persons = Person.all
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def index
  end

  def team
    @reviews = Review.where("person_id is NULL")
  end


end