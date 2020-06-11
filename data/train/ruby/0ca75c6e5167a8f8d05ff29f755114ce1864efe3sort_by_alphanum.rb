module Enumerable
  def sort_by_alphanum
    sort do |a, b|
      if block_given?
        grouped_compare(yield(a), yield(b))
      else
        grouped_compare(a, b)
      end
    end
  end

  def sort_by_alphanum!
    sort! do |a, b|
      if block_given?
        grouped_compare(yield(a), yield(b))
      else
        grouped_compare(a, b)
      end
    end
  end

  private

  def grouped_compare(a, b)
    loop {
      a_chunk, a = extract_alpha_or_number_group(a)
      b_chunk, b = extract_alpha_or_number_group(b)

      ret = if a_chunk =~ /\d/ and b_chunk =~ /\d/
              a_chunk.to_i <=> b_chunk.to_i
            else
              a_chunk <=> b_chunk
            end

      return -1 if a_chunk == ''
      return ret if ret != 0
    }
  end

  def extract_alpha_or_number_group(item)
    matchdata = /([A-Za-z]+|[\d]+)/.match(item)

    if matchdata.nil?
      ["", ""]
    else
      [matchdata[0], item = item[matchdata.offset(0)[1] .. -1]]
    end
  end
end
