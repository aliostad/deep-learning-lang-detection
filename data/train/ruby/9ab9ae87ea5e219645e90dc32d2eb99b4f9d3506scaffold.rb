module Autofold
  class Commander
    module Scaffold
      class << self
        def parse_to_simple_array(names)
          _second_dimensionalize _break_to_chunks(names)
        end

        private

        def _second_dimensionalize(array2)
          array2.inject([]) do |a2, row|
            a2 += _simplify_split(row)
          end
        end

        def _break_on_plus(names)
          _break_on_something(names, "+")
        end

        # takes str1:str2:str3 -> [str1, str2, str3] where any of the strs can be a 
        # complexed statement
        def _break_on_colon(names)
          _break_on_something(names, ":")
        end

        # things called first have lower operator precedence
        def _break_to_chunks(names)
          _break_on_plus(names).map { |chunk| _break_on_colon chunk }
        end

        def _malformed_input?(names)
          false
        end

        # Takes a row, and attempts to split it
        def _simplify_split(row)
          return [row] if _simple_row?(row)
          ind = _find_complex_chunk_index(row)
          left_row = row.dup.tap { |r| r[ind] = _split_chunk_left r[ind] }.flatten
          right_row = row.dup.tap { |r| r[ind] = _split_chunk_right r[ind] }.flatten
          _simplify_split(left_row) + _simplify_split(right_row)
        end

        def _find_complex_chunk_index(row)
          row.find_index { |c| _chunk_complex?(c) }
        end

        def _split_chunk_left(chunk)
          _split_chunk_somehow(chunk) { |c| c.first }
        end

        def _split_chunk_right(chunk)
          _split_chunk_somehow(chunk) { |c| c[1..-1].join "+" }
        end

        def _split_chunk_somehow(chunk)
          return _break_on_colon yield _break_on_plus(_strip_parenthesis chunk) if block_given?
          _break_on_colon _break_on_plus _strip_parenthesis chunk
        end 

        def _chunk_complex?(chunk)
          /(\+|:)/ =~ chunk
        end

        def _chunk_simple?(chunk)
          !_chunk_complex?(chunk)
        end

        def _simple_row?(row)
          row.inject(true) do |is_simple, chunk|
            is_simple && _chunk_simple?(chunk)
          end
        end

        def _completely_simple?(array2)
          array2.inject(true) do |is_simple, array|
            is_simple && _simple_row?(array)
          end
        end

        def _strip_parenthesis(str)
          _strip_outer_something _strip_outer_something(str, "("), ")"
        end

        def _strip_outer_something(str, something)
          str.gsub(Regexp.new("^\\#{something}"), "").chomp(something)
        end

        def _break_on_something(names, something)
          raise ArgumentError.new("Malformed Input!") if _malformed_input?(names)
          names.split("").inject(ParenthesisCountArray.new.push "") do |array, letter|
            array.push "" if letter == something && array.parenthesis_balanced?
            array.parenthesis_count += 1 if letter == "("
            array.parenthesis_count -= 1 if letter == ")" 
            array.last.concat letter
            array
          end.map do |chunk|
            _strip_outer_something chunk, something
          end
        end
      end

      class ParenthesisCountArray < Array
        def parenthesis_count
          @parenthesis_count ||= 0
        end
        def parenthesis_count=(n)
          @parenthesis_count = n
        end
        def parenthesis_balanced?
          parenthesis_count.zero?
        end
      end
    end
  end
end


