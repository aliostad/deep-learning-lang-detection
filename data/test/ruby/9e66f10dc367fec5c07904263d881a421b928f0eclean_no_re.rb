def number_words(number)
  big_numbers = {0=>'',1=>" thousand", 2=>" million", 3=> " billion", 4=>" trillion"}
  ones_teens = {0 => "", 1 => "one", 2 =>"two", 3 =>"three", 4=>"four", 5=>"five", 6=>'six', 7=>'seven', 8=>'eight', 9=>'nine', 10 =>'ten', 11=>'eleven', 12=>'twelve', 13=>'thirteen', 14=>'fourteen', 15=>'fifteen', 16=>'sixteen', 17=>'seventeen', 18=>'eighteen', 19=>'nineteen'}
  tens= {2=>"twenty ", 3=>"thirty ", 4=>"forty ", 5=>"fifty ", 6=>'sixty ', 7=>'seventy ', 8=>'eighty ', 9=>'ninety '}
  three_digit_chunks = []

  while number != 0 do
    three_digit_chunks.push(number % 1000)
    number = (number/1000).floor
  end

  three_digit_chunks.map!.with_index do |chunk,index|
    new_chunk = ''
    if chunk > 99
      new_chunk = ones_teens[(chunk/100).floor] + " hundred "
      chunk = chunk % 100
    end
    if chunk >= 20
      new_chunk += tens[chunk/10.floor]
      chunk = chunk % 10
    end
    if chunk > 0
      new_chunk += ones_teens[chunk]
    end
    chunk = new_chunk.strip + big_numbers[index]
  end

  three_digit_chunks.reverse.join(" ")
end
