class User < ActiveRecord::Base
  # devise setup
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :can_do_anything, :can_manage_tracks, :can_manage_users

  [:can_do_anything, :can_manage_tracks, :can_manage_users].each do |ability|
    define_method("#{ability}?") do 
      self.send(ability.to_sym) || self.can_do_anything
    end
  end

  alias_method :original_as_json, :as_json

  def as_json(options)
    json = original_as_json(options.merge(:only => [:id, :email, :can_do_anything, :can_manage_tracks, :can_manage_users, :can_manage_live_show, :can_broadcast]))
  end
end
