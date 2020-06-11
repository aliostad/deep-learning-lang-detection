module ManagePosts
  extend ActiveSupport::Concern

  included do
    helper_method :manage_posts_key, :manage_posts?
    helper PostsHelper
  end

  def manage_posts_key
    'manage_posts'
  end

  def stop_manage_posts
    user_session[manage_posts_key] = false
  end

  def manage_posts?
    user_signed_in? && user_session[manage_posts_key] == true
  end

  module PostsHelper

    def manage_posts_toggle
      button_classes = %w(btn btn-info btn-small btn-block)
      toggle_link_to 'Manage Posts', new_post_path, manage_posts_key, class: button_classes
    end
  end
end