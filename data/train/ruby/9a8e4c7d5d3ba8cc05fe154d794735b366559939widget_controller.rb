
class Widget::WidgetController < ApplicationController

  before_filter :validate_api_key

  helper_method :current_api_key

  protected

  def validate_api_key
    if current_api_key
      return true
    else
      respond_to do |format|
        format.xml do
          render :xml => Player::Error.new( :code => 403, :error => t('widget.missing_api_key') )
        end
      end
      return false
    end
  end

  def current_api_key
    WidgetApiKey.available.find_by_api_key( cookies[:cyloop_api_key] || params[:api_key] )
  end

  memoize :current_api_key

end