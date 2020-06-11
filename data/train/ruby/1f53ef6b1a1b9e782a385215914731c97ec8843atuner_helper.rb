module TunerHelper

  private
    def calculate_dyno_by_MMn(data)
      
      Rails.logger.debug { "Enter calculate_dyno_by_MMn() data=#{data.inspect}" }
      
      delta = 1  # too few dynos
      delta = -1 if data[:wanted_wait_time] > data[:actual_wait_time] # too many dynos

      l = data[:num_requests].to_f/data[:interval_time].to_f
      u = 1.to_f / data[:avg_service_time]
      
      dyno = data[:dyno]
      gap = (data[:wanted_wait_time] - data[:actual_wait_time]).abs
      
      Rails.logger.debug { "delta=#{delta},u=#{u}, l=#{l},dyno=#{dyno}, gap=#{gap}, current_wait_time=#{calculate_wait_time(dyno,u,l)}" }
      
      # queue will quickly have infinite number of requests, therefore, return max_dyno
      Rails.logger.debug { "l > (dyno*u) = #{l > (dyno*u)}" } 
      while (l > (dyno*u) and dyno <= data[:max_dyno])
        dyno = dyno + 1
      end
      
      while (data[:min_dyno] <= dyno && dyno <= data[:max_dyno])
          wait_time = calculate_wait_time(dyno + delta,u,l)
          Rails.logger.debug { "dyno=#{dyno+delta},wait=#{wait_time}" }
          
          dyno = dyno + delta
          
          # if ok, then break
          if (gap < (data[:wanted_wait_time]-wait_time).abs)
            
            break;
          end
          
          
          gap = (data[:wanted_wait_time]-wait_time).abs
          
          Rails.logger.debug { "gap=#{gap}"}
      end
      
      # ensure again
      dyno = data[:min_dyno] if dyno < data[:min_dyno]
      dyno = data[:max_dyno] if dyno > data[:max_dyno]
      
      Rails.logger.debug { "Exit calculate_dyno_by_MMn() with dyno=#{dyno},expected_wait_time=#{dyno}"}
    
      return dyno,wait_time
    end
  
  private
    def calculate_wait_time(c,u,l)
      
      Rails.logger.debug { "Enter calculate_wait_time()" }

      c = c.to_f
      roh = l / (c*u)
      
      b = calculate_b(c-1,c*roh)
      
      pie = calculate_pie(roh,b)
      
      Rails.logger.debug { "c=#{c},u=#{u},l=#{l},roh=#{roh},b=#{b},pie=#{pie}" }
      Rails.logger.debug { "Exit calculate_wait_time() with #{(pie/((c*u) - l))}" }
      
      return  pie / ((c*u) - l)
    end
  
  private
    def calculate_pie(roh,b)
      Rails.logger.debug { "Enter calculate_pie(), roh=#{roh},b=#{b}" }
      Rails.logger.debug { "Exit calculate_pie() with #{(roh*b / (1.to_f - roh + (roh*b)))}" }
      return roh*b / (1.to_f - roh + (roh*b))
    end
  
  private
    def calculate_b(c,roh)
      Rails.logger.debug { "Enter calculate_b(), c=#{c},roh=#{roh}" }
      b = 1.to_f
      (1..c).each { |f| 
        b = (roh * b) / (f + (roh*b))
      }
      
      Rails.logger.debug { "Exit calculate_b() with #{b}" }
      return b
    end
end
