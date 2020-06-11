class Chunker
  attr_reader :doc, :renderers, :emphasis, :strong

  def initialize(doc, renderers, emphasis, strong)
    @doc = doc
    @renderers = renderers
    @emphasis = emphasis
    @strong = strong
    @transformed_chunk
  end

  def result
    parsed_chunks = chunk(doc).map do |chunk|
      transform_chunk(chunk)
      make_strong
      make_emphasis
    end
    parsed_chunks.join
  end

  private

  def chunk(doc)
    doc.split("\n\n")
  end

  def transform_chunk(chunk)
    @transformed_chunk = renderer_for(chunk).transform(chunk)
  end

  def renderer_for(chunk)
    renderers.find { |r| r.handles?(chunk) }
  end

  def make_strong
    @transformed_chunk = strong.transform(@transformed_chunk)
  end

  def make_emphasis
    @transformed_chunk = emphasis.transform(@transformed_chunk)
  end
end