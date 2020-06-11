module Domain
  module AIS
    module Checksums
      def calculate(data)
        sum = 0 
        data.each_byte do |c|
          sum^=c
        end
        sum
      end
      
      def verify(packet)
        pair = packet[1..-1].split('*')
        if pair.length != 2
          false
        else
          sentence, checksum = pair
          calculate(sentence) == checksum.hex
        end
      end 
        
      def add(sentence)
        checksum = calculate(sentence[1..-1])
        sentence.dup << '*' << checksum.to_s(16).upcase.rjust(2, '0')
      end
      
      module_function :calculate, :verify, :add
    end
  end
end