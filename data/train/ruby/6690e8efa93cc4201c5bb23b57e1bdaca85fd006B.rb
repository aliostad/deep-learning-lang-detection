#!/usr/bin/env ruby

def snake_case?(str)
  chunks = str.split(/_/)
  str.size > 0 && chunks.all?{|chunk| chunk.match(/^[a-z][a-z0-9]*$/)}
end

def camel_case?(str)
  str.size > 0 && str.match(/^[a-z][a-zA-Z0-9]*$/)
end

str = gets.chomp
pre, body, suf = str.match(/^(_*)(.*?)(_*)$/).captures
if snake_case?(body)
  buf = ""
  body.split(/_/).each do |chunk|
    buf << chunk.capitalize
  end
  buf[0] = buf[0].swapcase
  buf = "#{pre}#{buf}#{suf}"
  puts buf
elsif camel_case?(body)
  buf = pre.to_s
  body.split(/([A-Z])/).each do |chunk|
    if chunk.match(/[A-Z]/)
      buf << "_#{chunk.downcase}"
    else
      buf << chunk
    end
  end
  buf << suf.to_s
  puts buf
else
  puts str
end

