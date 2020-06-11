  module MapReduce
      def get_worker(get_line,can_process,max_worker,processXtime)
          if get_line>((processXtime*can_process)*(max_worker+1))
              get_worker(get_line,can_process,max_worker+1,processXtime)
          else
              return max_worker+1
          end
      end
    
def divideWorker(get_line)
    maxworker=25
    can_process=100
    #~ get_line=12508
    processXtime=8
    worker_arr=[0]
    if(get_line<=can_process)
        worker_arr<<get_line if get_line>0
    else
        numofworker=get_line/can_process
        modofworker=get_line%can_process
        if numofworker >= maxworker
            temp_worker=numofworker/maxworker
            if temp_worker<=processXtime
                can_process=temp_worker*can_process
                numofworker=maxworker
            else
                numofworker = get_worker(get_line,can_process,maxworker,processXtime)
                can_process=get_line/numofworker
                modofworker=get_line%numofworker
            end  
        end        
        for i in 0...numofworker
            worker_arr<<can_process+worker_arr[i]
        end
        worker_arr<<get_line if modofworker>0
    end
    worker_arr
    #puts worker_arr.length
end
end    
#~ include MapReduce
#~ MapReduce.divideWorker(1)

