module StaticPagesHelper
  def calculate_perms word
    (1..word.length).reduce(&:*) / (calc_dup word.chars)
  end

  def calc_dup array
    counts = Hash.new(0)
    array.each { |word| counts[word] += 1 }
    counts.values.map { |e| (1..e).inject(&:*) }.reduce(&:*)
  end

  def calculate_index word
    total_count = 0
    return (total_count + 1) if word.length == 0

    target_letter = word[0]
    letters_done = []

    word.chars.sort.each do |e|
      letters_done.include?(e) ? next : letters_done << e
      if e == target_letter
        return total_count + calculate_index(word[1..-1])
      else
        total_count += calculate_perms(word.sub(e, ""))
      end
    end
  end
end
