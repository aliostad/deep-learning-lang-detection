#!/usr/bin/env ruby
#
# Stolen with gratitude from Tim C. Harper at http://gist.github.com/457860
def parse_chunk(chunk)
  remove_start_line, add_start_line = chunk.scan(/@@ -(\d+),\d+ \+(\d+),\d+/).flatten.map { |line| line.to_i }
  { :removed => chunk.grep(/^[- ]/),
    :added => chunk.grep(/^[+ ]/),
    :remove_start_line => remove_start_line,
    :add_start_line => add_start_line }
end

def parse_chunks(file_diff)
  file_diff.split(/^(?=@@)/)[1..-1].map {|chunk| parse_chunk(chunk)}
end

def extract_filename(patch)
  patch.scan(/diff --git a\/(.+?) b\//).flatten.first
end

def parse_patch(patch)
  patch.split(/^(?=diff --git)/).map do |file_chunk|
    { :file_name => extract_filename(file_chunk),
      :chunks => parse_chunks(file_chunk) }
  end
end

require 'pp'
pp(parse_patch(%x(git diff --cached)))
