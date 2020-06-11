class Array_groupings
  def initialize(args)
    @args = args
    @arr = @args[:arr].to_enum
    @debug = @args[:debug]
  end
  
  def parse
    return Enumerator.new do |yielder|
      prev_ele = @arr.next
      chunk = [prev_ele]
      chunks = [chunk]
      print "First ele: #{prev_ele}\n" if @debug
      
      begin
        while ele = @arr.next
          print "Ele: '#{ele}'\n" if @debug
          deletes = []
          adds = []
          
          chunks.each do |chunk_i|
            res_last = yield(chunk_i.last, ele)
            res_first = yield(chunk_i.first, ele)
            
            if res_first and res_last
              chunk_i << ele
            elsif !res_last and !res_first
              yielder << chunk_i
              deletes << chunk_i
              adds << [ele]
            elsif res_last and !res_first
              new_add = []
              chunk_i.each do |chunk_i_ele|
                if yield(chunk_i_ele, ele)
                  new_add << chunk_i_ele
                end
              end
              new_add << ele
              
              yielder << chunk_i
              adds << new_add
              deletes << chunk_i
            else
              raise "Dont know what to do here. First: #{chunk_i.first}, last: #{chunk_i.last}, ele: #{ele}, res_last: #{res_last}, res_first: #{res_first}"
            end
          end
          
          chunks -= deletes
          chunks += adds
        end
      rescue StopIteration
        chunks.each do |chunk|
          yielder << chunk
        end
      end
    end
  end
end