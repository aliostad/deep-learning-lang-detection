class WelcomeController < ApplicationController
  respond_to :html
  skip_before_filter :authenticate_user!

  def index
    respond_with
  end

  def about
    respond_with
  end

  def api
    add_breadcrumb  I18n.t('breadcrumbs.api'), '/api'
  end

  def api_public
    add_breadcrumb  I18n.t('breadcrumbs.api'), '/api'
    add_breadcrumb  I18n.t('breadcrumbs.api_public'), '/api/public'
  end

  def api_private
    add_breadcrumb  I18n.t('breadcrumbs.api'), '/api'
    add_breadcrumb  I18n.t('breadcrumbs.api_private'), '/api/private'
  end
end
