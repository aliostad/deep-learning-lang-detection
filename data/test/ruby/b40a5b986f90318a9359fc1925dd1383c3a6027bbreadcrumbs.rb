$:.push File.expand_path("../lib", __FILE__)

require_relative "bready/version"

module Bready
  class Breadcrumbs
    @@delimiter = ' &gt; '
    @@block_class = 'breadcrumbs'
    @@block_tag = 'div'
    @@root_chunk = []

    def initialize(chunks)
      @chunks = chunks
    end

    def self.setup
      yield self
    end

    def self.delimiter= value
      @@delimiter = value
    end

    def self.block_class= value
      @@block_class = value
    end

    def self.block_tag= value
      @@block_tag = value
    end

    def self.root_chunk= value
      @@root_chunk = value
    end

    def add_chunks(chunks)
      chunks.each{|chunk| add_chunk(chunk)}
    end

    def add_chunk(chunk)
      @chunks << chunk
    end

    def render
      "<#{@@block_tag} class='#{@@block_class}' xmlns:v='http://rdf.data-vocabulary.org/#'>#{render_chunks}</#{@@block_tag}>"
    end

    private

    def render_chunks
      rendered = ''
      @chunks.unshift(@@root_chunk).map do |label, url|
        rendered << @@delimiter unless rendered.empty?
        if url
          rendered << "<span typeof='v:Breadcrumb'><a href='#{url}' rel='v:url' property='v:title'>#{label}</a></span>"
        else
          rendered << "<span>#{label}</span>"
        end
      end
      rendered
    end

  end

end