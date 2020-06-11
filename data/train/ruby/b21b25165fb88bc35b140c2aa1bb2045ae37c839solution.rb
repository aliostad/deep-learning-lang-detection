def calculate_string_beauty(string)
  frequency_of_letters = calculate_frequency_of_letters(string)
  beauty_factor = 26
  beauty_index  = 0
  frequency_of_letters.each do |letter,frequency|
    beauty_index  += frequency * beauty_factor
    beauty_factor -= 1
  end
  beauty_index
end

def calculate_frequency_of_letters(string)
  string.downcase
        .gsub(/[^a-z]/, '')
        .split('')
        .inject(Hash.new(0)) { |h,v| h[v] += 1; h }
        .sort_by(&:last)
        .reverse
end

File.open(ARGV[0]) do |file|
  file.each_line do |line|
    puts calculate_string_beauty(line)
  end
end
