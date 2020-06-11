# text_parse.rb - class TextParse

class TextParse
  def initialize
    @keywords = ['ital', 'bold', 'code', 'strike', 'quote', '=']
  end
  def lexer string
  string.split(/[\[\]]/).select {|e| !e.empty? }
  end

  # chunks array into array of 2 element arrays : ['ab'] => [[:t, 'ab']]
  def chunker arr
    arr.map do |e|
      chunk = e.split(' ')
      if @keywords.member? chunk[0]
      chunk[0] = 'equal' if chunk[0] == '='
      [chunk[0].to_sym, chunk[1..(-1)].join(' ')]
      else
        [:t, e]
      end
    end
  end
  
  def parse string
    chunker lexer(string)
  end
end
