module Nums_to_words
  class :: Fixnum
    
    def in_words 
      answer = []  
      num = self
      
      if num.to_i == 0
         answer.push "zero"
      end
    
      nums_in_words = {1 => "one", 2 => "two", 3 => "three", 4 => "four",
                      5 => "five", 6 => "six", 7 => "seven", 8 => "eight", 9 => "nine",
                     10 => "ten", 11 => "eleven", 12 => "twelve", 13 => "thirteen",
                     14 => "fourteen", 15 => "fifteen", 16 => "sixteen", 17 => "seventeen",
                     18 => "eighteen", 19 => "nineteen", 20 => "twenty", 30 => "thirty",
                     40 => "forty", 50 => "fifty", 60 => "sixty", 70 => "seventy",
                     80 => "eighty", 90 => "ninety", 100 =>  "hundred"}
                     
      num_places  =  {1 => "thousand", 2 => "million", 3 => "billion", 4 => "trillion"}  
      
      count = 0
      chunk_array = []
      
      while num > 0  
        num_chunk = num % 1000
        num = num/1000
        while num_chunk > 0
          if num_chunk.to_f/100.0 >= 1
            chunk_array.push nums_in_words[num_chunk.to_i/100]
            chunk_array.push nums_in_words[100]
            num_chunk = num_chunk%100
          elsif num_chunk.to_f/10.0 >= 2
            chunk_array.push nums_in_words[(num_chunk-(num_chunk%10))]
            num_chunk = num_chunk%10  
          else 
            chunk_array.push nums_in_words[num_chunk]
            num_chunk = 0
          end
        end
        if !chunk_array.empty? 
          chunk_array.push num_places[count]
          answer.unshift chunk_array.join(" ")
          chunk_array.clear
        end
        count += 1
      end
      return answer.join(" ").strip
    end 
  end
end



