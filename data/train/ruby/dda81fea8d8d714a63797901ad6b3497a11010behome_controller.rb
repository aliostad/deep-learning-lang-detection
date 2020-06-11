class HomeController < ApplicationController

  before_filter :require_login
  
  def index
    unless cookies[:api_key].blank?
      @api_key = cookies[:api_key]
    end
    
    unless cookies[:api_secret].blank?
      @api_secret = cookies[:api_secret]
    end
    
    @api_key ||= nil
    @api_secret ||= nil

  end
  
  def group_search
    
  end
  
  def upload
    api_key = params[:auth][:api_key]
    api_secret = params[:auth][:api_secret]
    
    cookies[:api_key] = { :value => api_key, :expires => 1.year.from_now }
    cookies[:api_secret] = { :value => api_secret, :expires => 1.year.from_now }
    
    audio = DataFile.save(params[:datafile])
    
    payload = {:criteria => params[:criteria]}.merge(params[:auth])
    api = LmcApi.new(api_key, api_secret)

    result = api.post_json(payload, "insertCall")
    call_detail = JSON::parse result
    
    if call_detail.nil? or call_detail['status'] == "error"
      render :text => "Error! #{result}"
      return
    end
    
    cid = call_detail['call_detail']['id']
    
    result = api.post_media({:audio => audio, :call_detail_id => cid})
    recording = JSON::parse result
    render :text => recording.merge(call_detail).to_json
  end
end
  