class RubySimF::ThreadManager

  def initialize  
    @threads_list = []
  end
=begin    
  def yield_control_to(process,main_process=nil)
    thread = wakeup(process)
    #thread.pass
    #main_process.wakeup
    while process.thread.status != false && process.thread.status != "sleep"
      process.thread.join(RubySimF::Constants::WAIT_TIME_FOR_SLEEP)
      RubySimF::Logger.instance.debug("Sleep for process: <#{process.name}>", 
      RubySimF::Simulator.instance.clock)
    end
  end   
  
  def wakeup(process)
    RubySimF::Logger.instance.info(
    "Wakeup the process: <#{process.name}>", 
    RubySimF::Simulator.instance.clock)
    if process.thread.status == "sleep" 
      #Thread.pass
      thread = process.thread.wakeup    
      #Thread.critical = true
      #Thread.pass
      #thread.join
      #Thread.pass
      #Thread.critical = false
      
      #Thread.stop
    end
    #pr = Thread.current
    #process.thread.value
    #pr.stop
    return process.thread    
    
  end  
=end

  def yield_control_to(process)
    thread = wakeup(process)
    while thread.status != false && thread.status != "sleep"
      thread.join(RubySimF::Constants::WAIT_TIME_FOR_SLEEP)
      RubySimF::Logger.instance.info("Sleep for process: <#{process.name}>", 
      RubySimF::Simulator.instance.clock)
    end
  end   

  def wakeup(process)
    RubySimF::Logger.instance.info(
    "Wakeup the process: <#{process.name}>", 
    RubySimF::Simulator.instance.clock) 
    return process.thread.wakeup if process.thread.status == "sleep"
    return process.thread
  end  
 
  def terminate(processes, stop)
    processes.each{|process|
       if process.thread.status != "sleep" || 
         (process.thread.status !=false && stop)
         process.thread.exit
       end
    }
  end

end
     