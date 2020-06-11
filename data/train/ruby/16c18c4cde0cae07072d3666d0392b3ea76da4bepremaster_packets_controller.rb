class PremasterPacketsController < ApplicationController
  
  def create
    
    premaster_guid = params[:premaster_id]
    position = params[:position]
    timestamp = params[:timestamp]
    chunk = params[:chunk]
    length = params[:length]
    
    # Why is not working?
    # raise "length #{length.to_i} != chunk length #{chunk.length}" if chunk.length != length.to_i
    
    packet = PremasterPacket.new :premaster_guid => premaster_guid, :client_timestamp => timestamp, :position => position.to_i, :chunk => chunk
    
    packet.save!
    render :text => "OK", :status => 200
    
  rescue => exc
    
    logger.error("Message for the log file #{exc.message}")
    render :text => "error", :status => 500
    
  end
  
end
