# encoding: utf-8

module VideoScreenshoter
  class Hls < Abstract

    def initialize params
      super
    end

    def run
      chunk_limits = []
      chunks.inject(0.0) do |time, chunk|
        chunk_limits.push({:start => time, :end => time + chunk.first, :path => chunk.last})
        time + chunk.first
      end
      threads = []
      times.each do |time|
        threads << Thread.new do
          if chunk_limit = chunk_limits.select { |c| time >= c[:start] && time <= c[:end] }.first
            path = File.join(File.dirname(input), chunk_limit[:path])
            rel_time = time - chunk_limit[:start]
            cmd = ffmpeg_command(path, output_fullpath(time), rel_time)
            puts cmd if verbose
            `#{cmd}`
            imagemagick_run output_fullpath(time)
          else
            puts "Time #{time} is incorrect" if verbose
          end
        end
      end
      threads.each { |t| t.join  }
    end

    alias :make_screenshots :run
    alias :make_thumbnails :run

    private
    
    attr_accessor :chunks

    def input_duration
      (self.chunks = parse_playlist).map(&:first).inject(:+)
    end
    
    def parse_playlist
      require 'open-uri'
      open(input) { |f| f.read }.scan(/EXTINF:([\d.]+).*?\n(.*?)\n/).map { |c| [c.first.to_f, c.last] }
    end
  end
end
