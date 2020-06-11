module ManageFilters
  extend ActiveSupport::Concern

  included do
    helper_method :manage_filters_key
    helper FiltersHelper
  end

  def manage_filters_key
    'manage_filters'
  end

  def stop_manage_filters
    user_session[manage_filters_key] = false
  end

  module FiltersHelper
    def manage_filters?
      user_signed_in? && user_session[manage_filters_key] == true
    end

    def manage_filters_toggle
      button_classes = %w(manage-tags btn btn-primary btn-small btn-block)
      toggle_link_to 'Manage Tags', filters_path, manage_filters_key, class: button_classes
    end
  end
end