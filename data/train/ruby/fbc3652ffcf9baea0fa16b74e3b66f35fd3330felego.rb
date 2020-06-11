require 'set'
module Lego
  class Inventory
    def self.from_i max_plus_one, min = 0
      max = max_plus_one.to_i - 1
      # puts "creating range from 0..#{max}"
      from_r Range.new( min, max )
    end

    class << self
      alias_method :generate, :from_i
    end

    def self.from_r range
      new.tap do |inventory|
        range.each do |piece|
          inventory.add piece
        end
      end
    end

    def initialize name="legos I'm playing with"
      @name = name
      @set = Set.new
    end

    def add new_piece_or_chunk
      @set.add new_piece_or_chunk
    end

    # Replace inventory's reference(s) to a_piece, another_piece, and/or their associated-Chunk(s)
    # with a new Chunk containing both
    def connect a_piece, another_piece
      # puts "locating #{a_piece} and #{another_piece}"
      a_piece_or_chunk = locate a_piece
      another_piece_or_chunk = locate another_piece

      # puts "=> #{a_piece_or_chunk} union #{another_piece_or_chunk}"
      new_chunk = if a_piece_or_chunk.respond_to? :union
                    a_piece_or_chunk.union another_piece_or_chunk
                  elsif another_piece_or_chunk.respond_to? :union
                    another_piece_or_chunk.union a_piece_or_chunk
                  else
                    Chunk.new [ a_piece_or_chunk, another_piece_or_chunk ]
                  end

      if new_chunk
        unless new_chunk.is_a?( Lego::Chunk )
          warn "ALERT: new chunk is_a? #{new_chunk.class}"
        end
        @set.delete a_piece_or_chunk
        @set.delete another_piece_or_chunk
        add new_chunk
      else
        warn "ALERT: no new chunk for #{a_piece_or_chunk} union #{another_piece_or_chunk}"
      end
    end
    alias_method :union, :connect

    # searching for a connection between two pieces
    def connected? a_piece, another_piece
      a_piece_or_chunk = locate a_piece
      return false unless a_piece_or_chunk.respond_to? :include?
      return !! a_piece_or_chunk.include?( another_piece )
    end
    alias_method :find?, :connected?

    private

    def locate piece
      # puts "searching for #{piece}"
      @set.find do |element|
        # puts "in #{element.inspect}"
        element.respond_to?( :include? ) ? element.include?( piece ) : element == piece
      end
    end
  end

  class Chunk
    attr_reader :chunk
    def initialize pieces
      @chunk = Set.new pieces
    end

    def add another_piece_or_chunk
      chunk.add piece_or_chunk( another_piece_or_chunk )
    end

    def union another_piece_or_chunk
      Chunk.new chunk.union( enumerable_piece_or_chunk( another_piece_or_chunk ) )
    end

    def include? another_piece_or_chunk
      chunk.include? piece_or_chunk( another_piece_or_chunk )
    end

    private
    def enumerable_piece_or_chunk _piece_or_chunk
      result = piece_or_chunk _piece_or_chunk
      result.is_a?( Enumerable ) ? result : [ result ]
    end

    def piece_or_chunk _piece_or_chunk
      _piece_or_chunk.respond_to?( :chunk ) ?  _piece_or_chunk.chunk : _piece_or_chunk
    end
  end
end
