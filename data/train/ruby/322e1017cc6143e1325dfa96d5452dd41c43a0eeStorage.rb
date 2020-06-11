
module Constants
  UNBLOCK_TIMEOUT = 60
  DELETION_TIMEOUT = 300
end


class Storage
  
  def initialize
    @verbose = false
    @blocked_api_keys = Hash.new
    @unblocked_api_keys = Hash.new
  end
  
  
  def add_unblocked_key(api_key)
    @unblocked_api_keys[api_key] = Time.now
  end
  
  
  def unblock_blocked_key(api_key)
    timestamp = @blocked_api_keys.delete(api_key)
    if timestamp == nil
      false
    else
      add_unblocked_key api_key
      true
    end
  end
  
  
  def get_unblocked_key
    if @unblocked_api_keys.length == 0
      false
    else
      api_key, timestamp = @unblocked_api_keys.shift
      @blocked_api_keys[api_key] = Time.now
      api_key
    end
  end
  
  
  def delete_key(api_key)
    timestamp = @blocked_api_keys.delete api_key
    if timestamp == nil
      timestamp = @unblocked_api_keys.delete api_key
      if timestamp == nil
        false
      else
        true
      end
    else
      true
    end
  end
  
  
  def refresh_key(api_key)
    if @unblocked_api_keys[api_key] == nil
      false
    else
      @unblocked_api_keys[api_key] = Time.now
      true
    end
  end
  
  
  def getTimestamp(api_key)
    if @unblocked_api_keys[api_key] != nil
      @unblocked_api_keys[api_key]
    elsif @blocked_api_keys[api_key] != nil
      @blocked_api_keys[api_key]
    else
      false
    end
  end
  
  
  def setTimestamp(api_key, timestamp)
    if @unblocked_api_keys[api_key] != nil
      @unblocked_api_keys[api_key] = timestamp
    elsif @blocked_api_keys[api_key] != nil
      @blocked_api_keys[api_key] = timestamp
    end
  end
  
  
  def periodic_refresh
    cur_time = Time.now
    @blocked_api_keys.each do |api_key, timestamp|
      if cur_time - timestamp > Constants::UNBLOCK_TIMEOUT
        @blocked_api_keys.delete(api_key)
        @unblocked_api_keys[api_key] = cur_time
        if @verbose
          p "API key auto-unblocked: #{api_key}"
        end
      end
    end
    
    @unblocked_api_keys.each do |api_key, timestamp|
      if cur_time - timestamp > Constants::DELETION_TIMEOUT
        @unblocked_api_keys.delete(api_key)
        if @verbose
          p "API key auto-deleted: #{api_key}"
        end
      end
    end
  end
  
  
  def list_keys
    p @blocked_api_keys
    p @unblocked_api_keys
  end
  
end
