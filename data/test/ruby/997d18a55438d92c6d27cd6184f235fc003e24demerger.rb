module Dyph
  module Support
    class Merger
      attr_reader :result, :diff2
      def self.merge(left, base, right, diff2: Dyph::Differ.default_diff2, diff3: Dyph::Differ.default_diff3)
        merger = Merger.new(left: left, base: base, right: right, diff2: diff2, diff3: diff3)
        merger.execute_three_way_merge()
        merger.result
      end

      def initialize(left:, base:, right:, diff2:, diff3:)
        @result = []
        @diff2 = diff2
        @diff3 = diff3
        @text3 = Text3.new(left: left, right: right, base: base)
      end

      # rubocop:disable Metrics/AbcSize
      def execute_three_way_merge
        d3 = @diff3.execute_diff(@text3.left, @text3.base, @text3.right, @diff2)
        chunk_descs = d3.map { |raw_chunk_desc| ChunkDesc.new(raw_chunk_desc) }
        index = 1
        chunk_descs.each do |chunk_desc|
          initial_text = []

          (index ... chunk_desc.base_lo).each do |lineno|                  # exclusive (...)
            initial_text << @text3.base[lineno - 1]
          end
          #initial_text = initial_text.join("\n") + "\n"
          #
          @result << Dyph::Outcome::Resolved.new(initial_text) unless initial_text.empty?

          interpret_chunk(chunk_desc)
          #assign index to be the line in base after the conflict
          index = chunk_desc.base_hi + 1
          #
        end

        #finish by putting all text after the last conflict into the @result body.

        ending_text = accumulate_lines(index, @text3.base.length, @text3.base)

        @result << Dyph::Outcome::Resolved.new(ending_text) unless ending_text.empty?
      end
      # rubocop:enable Metrics/AbcSize

      protected
        def set_conflict(chunk_desc)
          conflict = Dyph::Outcome::Conflicted.new(
            left:   accumulate_lines(chunk_desc.left_lo, chunk_desc.left_hi, @text3.left),
            base:   accumulate_lines(chunk_desc.base_lo, chunk_desc.base_hi, @text3.base),
            right:  accumulate_lines(chunk_desc.right_lo, chunk_desc.right_hi, @text3.right)
          )
          @result << conflict
        end

        def determine_conflict(d, left, right)
          ia = 1
          d.each do |raw_chunk_desc|
            chunk_desc = ChunkDesc.new(raw_chunk_desc)
            (ia ... chunk_desc.left_lo).each do |lineno|
              @result <<  Dyph::Outcome::Resolved.new(accumulate_lines(ia, lineno, right))
            end

            outcome =  determine_outcome(chunk_desc, left, right)
            ia = chunk_desc.right_hi + 1
            @result << outcome if outcome
          end

          final_text = accumulate_lines(ia, right.length + 1, right)
          @result <<  Dyph::Outcome::Resolved.new(final_text) unless final_text.empty?
        end

        def determine_outcome(chunk_desc, left, right)
          if chunk_desc.action == :change
            Outcome::Conflicted.new(
              left: accumulate_lines(chunk_desc.right_lo, chunk_desc.right_hi, left),
              right: accumulate_lines(chunk_desc.left_lo, chunk_desc.left_hi, right),
              base: []
            )
          elsif chunk_desc.action == :add
            Outcome::Resolved.new(
              accumulate_lines(chunk_desc.right_lo, chunk_desc.right_hi, left)
            )
          end
        end

        def set_text(orig_text, lo, hi)
          text = [] # conflicting lines in right
          (lo .. hi).each do |i|                   # inclusive(..)
            text << orig_text[i - 1]
          end
          text
        end

        def _conflict_range(chunk_desc)
          right = set_text(@text3.right, chunk_desc.right_lo,  chunk_desc.right_hi)
          left =  set_text(@text3.left , chunk_desc.left_lo,   chunk_desc.left_hi)
          d = @diff2.diff(right, left)
          if (_assoc_range(d, :change) || _assoc_range(d, :delete)) && chunk_desc.base_lo <= chunk_desc.base_hi
            set_conflict(chunk_desc)
          else
            determine_conflict(d, left, right)
          end
        end

        def interpret_chunk(chunk_desc)
          if chunk_desc.action == :choose_left
            # 0 flag means choose left.  put lines chunk_desc[1] .. chunk_desc[2] into the @result body.
            temp_text = accumulate_lines(chunk_desc.left_lo, chunk_desc.left_hi, @text3.left)
            # they deleted it, don't use if its only a new line
            @result <<  Dyph::Outcome::Resolved.new(temp_text) unless temp_text.empty?
          elsif chunk_desc.action != :possible_conflict
            # A flag means choose right.  put lines chunk_desc[3] to chunk_desc[4] into the @result body.
            temp_text = accumulate_lines(chunk_desc.right_lo, chunk_desc.right_hi, @text3.right)
            @result << Dyph::Outcome::Resolved.new(temp_text) unless temp_text.empty?
          else
            _conflict_range(chunk_desc)
          end
        end

        # @param [in] diff        conflicts in diff structure
        # @param [in] diff_type   type of diff looked for in diff
        # @return diff_type if any conflicts in diff are of type diff_type.  otherwise return nil
        def _assoc_range(diff, diff_type)
          diff.each do |d|
            if d[0] == diff_type
              return d
            end
          end
          nil
        end

        # @param [in] lo        indec for beginning of accumulation range
        # @param [in] hi        index for end of accumulation range
        # @param [in] text      array of lines of text
        # @return a string of lines lo to high joined by new lines, with a trailing new line.
        def accumulate_lines(lo, hi, text)
          lines = []
          (lo .. hi).each do |lineno|
            lines << text[lineno - 1] unless text[lineno - 1].nil?
          end
          lines
        end
    end

    class Text3
      attr_reader :left, :right, :base
      def initialize(left:, right:, base:)
        @left = left
        @right = right
        @base = base
      end
    end

    class ChunkDesc
      attr_reader :action, :left_lo, :left_hi, :right_lo, :right_hi, :base_lo, :base_hi
      def initialize(raw_chunk)
        @action   = raw_chunk[0]
        @left_lo  = raw_chunk[1]
        @left_hi  = raw_chunk[2]
        @right_lo = raw_chunk[3]
        @right_hi = raw_chunk[4]
        @base_lo  = raw_chunk[5]
        @base_hi  = raw_chunk[6]
      end
    end
  end
end