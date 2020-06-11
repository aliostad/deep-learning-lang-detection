module Hedbergism
  class Quote
    
    attr_reader :quote, :location, :date, :chunk, :length_of_chunk
    
    def initialize(line)
      @quote, @location, @date = line.split('~~')
      @chunk = []
      @length_of_chunk = 75
    end
    
    def to_s
      @quote.chomp
    end
    
    def banner
      chunks
      output = "\#" * (@length_of_chunk + 5) + "\n"
      output += blank_line
      @chunk.each do |a|
        newline = "\# " + a
        newline = newline.ljust(@length_of_chunk + 5)
        newline[-1] = "\#"
        output += "#{newline}\n"
      end
      
      output += blank_line + output_quote_attributes(@location) if @location
      output += output_quote_attributes(@date)     if @date
      
      output += blank_line
      output += "\#" * (@length_of_chunk + 5) + "\n"
      
      @quote ? output : ""
    end
    
    def blank_line
      "\#" + " " * (@length_of_chunk + 3) + "\#\n"
    end
    
    def output_quote_attributes(text)
      "\#" + text.rjust(@length_of_chunk + 2) + " \#\n"
    end
    
    def chunks(length=75, char=' ')
      workingline = ''
      @length_of_chunk = length
      quote.split(char).each do |word|
        if workingline.length + word.length + char.length <= length
          workingline += word + char
        else
          @chunk.push(workingline[0..-2])
          workingline = word + char
        end
      end
      @chunk.push(workingline[0..-2])
    end
  end
    
end