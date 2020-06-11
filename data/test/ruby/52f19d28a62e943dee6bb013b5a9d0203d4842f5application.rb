around_filter :record_memory  
  def record_memory  
    process_status = File.open("/proc/#{Process.pid}/status")  
    13.times { process_status.gets }  
    rss_before_action = process_status.gets.split[1].to_i  
    process_status.close  
    yield  
    process_status = File.open("/proc/#{Process.pid}/status")  
    13.times { process_status.gets }  
    rss_after_action = process_status.gets.split[1].to_i  
    process_status.close  
    logger.info("CONSUME MEMORY: #{rss_after_action - rss_before_action} \  
KB\tNow: #{rss_after_action} KB\t#{request.url}")  
  end  
