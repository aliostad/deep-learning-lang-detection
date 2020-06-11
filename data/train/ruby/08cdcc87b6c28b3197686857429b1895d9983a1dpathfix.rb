module Assetify
  #
  # *Attempt* to fix assets in js/css for #image_url
  #
  class Pathfix
    def initialize(chunk, renderer = :erb, ns = nil)
      @chunk = chunk
      @renderer = renderer
      @ns = ns
      @images = scan_images
    end

    attr_reader :images

    def scan_images
      @chunk.scan(%r{url\(([a-zA-Z0-9/\_\-\.]*\.\w+)\)}xo).flatten
    end

    def replace(src)
      fpath = @ns ? "#{@ns}/#{src}" : src
      if @renderer == :erb
        "url('<%= image_path('#{fpath}') %>')"
      else
        "image-url('#{fpath}')"
      end
    end

    def fix
      @images.each do |path|
        @chunk["url(#{path})"] = replace path.split('/').last
      end
      @renderer != :erb ? tmpl_chunk : @chunk
    end

    def tmpl_chunk
      require 'sass/css'
      Sass::CSS.new(@chunk).render(@renderer)
    rescue Sass::SyntaxError => e
      @error = e
    end
  end
end
