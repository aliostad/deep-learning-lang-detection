class SentimentAnalyser::NGramSegmentizer

  def initialize(n:,lang: :en, include_monograms: false)
    @n = n
    @segmentizer_class = Tokenizer::Tokenizer.new(lang)
    @include_monograms = include_monograms
  end

  def segmentize(text)
    text.gsub!(/(@|#)/,"")
    text.gsub!(/https?:\/\/[\S]+/,"URL")

    words = @segmentizer_class.tokenize(text).
      map(&:downcase).
      reject(&:blank?)

    chunks = split(words)

    ngrams =   chunks.map {|chunk| chunk.each_cons(@n).to_a}.flatten(1).map {|ngram| ngram.join(" ")}

    ngrams += chunks.flatten if @include_monograms

    ngrams
  end


  private
  def split(array)
    splitter = %w{, ; . : - _ < > \  [ ] ! ? = " & / | ( ) -- *}

    result = []
    current_chunk = []

    array.each do |content|
      if splitter.include? content
        result << current_chunk
        current_chunk = []
      elsif content =~ /\.?\d/
        current_chunk << "NUMBER"
      else
        current_chunk << content
      end
    end

    result << current_chunk if current_chunk.any?

    result
  end
end