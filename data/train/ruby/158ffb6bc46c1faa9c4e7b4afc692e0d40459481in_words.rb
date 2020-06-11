module InWords
  def in_words
    number = self
    if number == 0 then return 'zero' end

    ones = %w(one two three four five six seven eight nine)
    teens = %w(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
    tens = %w(twenty thirty forty fifty sixty seventy eighty ninety)
    bigs = %w(thousand million billion trillion)

    all_words = []
    chunks = number.to_s.reverse.scan(/.{1,3}/).map { |s| s.reverse.to_i }

    chunks.each_with_index do |chunk, i|
      if chunk > 0 # if chunk is 000 nothing happens
        words = []
        if chunk >= 100 then words << [ones[chunk / 100 - 1], 'hundred'] end #every chunk >100 includes word 'hundred'
          
        if chunk % 100 > 0 #ex. if chunk is 100 nothing else happens
          if chunk % 100 >= 10 && chunk % 100 < 20 #teens; need to be first into the words
            words << teens[chunk % 100 - 10]
          else 
            if chunk % 100 >= 20 then words << tens[chunk % 100 / 10 - 2] end # >teens 
            if chunk % 10 > 0 then words << ones[chunk % 10 - 1] end #<teens 
          end
        end

        if i != 0 then words << bigs[i-1] end #greater than hundreds?
        all_words << words.join(' ')#enter results of this loop into the master array
        
      end
    end #ends loop
    all_words.reverse.join(' ')
  end #method
end #module

class Fixnum
  include InWords
end




   