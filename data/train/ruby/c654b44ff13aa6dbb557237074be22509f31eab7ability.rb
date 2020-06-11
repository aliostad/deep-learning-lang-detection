class Ability
  include CanCan::Ability
  def initialize(user)
    
    #
    # signed in user
    #
    unless user.blank?
      
      can [ :create, :new ], Gallery
      can [ :edit, :update, :destroy_photo ], Gallery do |g|
        g.user == user
      end

      can [ :new ], Message

      can [ :create ], Newsitem

      can [ :upload, :driver, :set_profile_photo, :new_profile_photo ], Photo
      can [ :move, :edit, :update, :show ], Photo do |photo|
        photo.user == user
      end
      can [ :show ], Photo do |photo|
        photo.viewer_ids.include? user.id || user == photo.user
      end
      can [ :destroy ], Photo do |photo|
        if photo.user == user
          if photo.gallery.blank?
            true
          elsif photo.gallery.is_anonymous
            false
          else
            true
          end
        else
          false
        end
      end

      can [ :new, :create, :search, :index, :my_index ], Report
      can [ :edit, :update ], Report do |r|
        r.user == user
      end
      
      can [ :organizer, :photos, :new_profile, :create_profile, :edit_profile, :update_profile ], User
      can [ :edit, :update, :update_profile ], User do |uu|
        uu == user
      end

      can [ :new ], Venue

      can [ :new, :create ], Video

      # manager
      #
      if user[:group_id] <= 2        
        can [ :manage ], CitiesUser
        can [ :manage ], City
        can [ :manage ], Country
        # can [ :manage ], Day
        can [ :manage ], Event
        can [ :manage ], Feature
        can [ :manage ], Gallery
        can [ :manage ], Newsitem
        can [ :manage ], Nodeitem
        can [ :manage ], Photo
        can [ :manage ], Report
        can [ :manage ], Site
        can [ :manage ], Tag
        can [ :manage ], User
        can [ :manage ], UserProfile
        can [ :manage ], Venue
        can [ :manage ], Video
        can [ :manage ], Welcome
        can [ :manage ], Manager
        can [ :manage ], ManagerCity
        can [ :manage ], ManagerGallery
        can [ :manage ], ManagerPhoto
        can [ :manage ], ManagerReport
        can [ :manage ], ManagerTag
        can [ :manage ], ManagerUser
        can [ :manage ], ManagerVenue
      end

      #
      # if admin
      #
      can :manage, :all do
        user.group_id.to_s == "1"
      end

    end    
    user ||= User.new
    
    ###
    ### applies to all users
    ###

    can [ :render_partial ], AuxModel
    
    can [ :new ], Event

    can [ :index, :search, :not_found, :set_show_style, :new ], Gallery
    can [ :show ], Gallery do |g|
      g.is_public && !g.is_trash
    end

    can [ :error500, :search ], Manager

    # has to be outside user auth b/c the uploading component is ajax.
    can [ :new, :create, :index, :do_upload, :not_found ], Photo
    can [ :show ], Photo do |photo|
      photo.is_public && !photo.is_trash
    end
    
    can [ :index, :search, :not_found, :new ], Report
    can [ :show ], Report do |r|
      r.is_public && !r.is_trash
    end

    can [ :new ], Review
       
    can [ :show, :newsitems, :features, :newsitems ],  Site

    can [ :index ], Tag
    can [ :show ], Tag do |t|
      true
    end

    can [ :resume, :reports, :galleries, :report, :gallery,
      :sign_in, :sign_up, :sign_out, :logout,
      :index, :show, :not_found, :github, :about ], User
    can [ :report ], User do |r|
      r.is_public && !r.is_trash
    end
    
    can [ :new, :index, :show, :not_found ], Venue

    can [ :index, :show, :view ], Video

  end
end

