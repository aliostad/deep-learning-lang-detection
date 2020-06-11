module Domain
  module AIS
    module SixBitEncoding

      def encode_chunk(chunk)
        value = chunk.to_i(2)
        case value
        when (0..39) 
          ascii = value + 48
        when (40..63)
          ascii = value + 48 + 8
        else
          raise "Encoding error for bit pattern " << chunk 
        end
        ascii.chr
      end
    
      def encode(binary_string)
            
        # Add padding zeroes to end
        if binary_string.length % 6 > 0
          binary_string << '0' * (6 - binary_string.length % 6) 
        end
        
        chunk_count = binary_string.length / 6
        encoded = ""
        1.upto(chunk_count) do |i|
          a = i*6-1
          chunk = binary_string[a-5..a]
          
          encoded << encode_chunk(chunk)
        end
        encoded
      end
    
      def decode_character(character)
        ascii = character[0].ord
        case ascii
        when (48..87) 
          value = ascii - 48
        when (96..119)
          value = ascii - 48 - 8
        else
          raise "Decoding error for character " << character 
        end
        value.to_s(2).rjust(6, '0')
      end
    
      def decode(sixbit)
        binaryString = ""
        sixbit.each_char do |c|
          binaryString << decode_character(c)
        end
        binaryString
      end
      
      module_function :encode_chunk, :encode, :decode_character, :decode
    end
  end
end