require 'memosig/output'

class ::Memosig::Matcher
  include Memosig::Output

  def initialize(pattern, config)
    @pattern, @config = prepare_pattern(pattern), config
  end

  def match?(process)
    @process = process
    if @process.command =~ @pattern
      if @process.rss > @config.rss_max
        take_action
      else
        lay_low
      end
      true
    else
      false
    end
  end

  private

  def prepare_pattern(pattern)
    Regexp.new(pattern.to_s)
  end

  def take_action
    output "sending signal #{@config.signal} to process pid=#{@process.pid} "\
      "pattern=#{@pattern.source.inspect} "\
      "rss #{@process.rss}>#{@config.rss_max}"
    Process.kill @config.signal, @process.pid
  end

  def lay_low
    output "no action on process pid=#{@process.pid} "\
      "pattern=#{@pattern.source.inspect} "\
      "rss #{@process.rss}<=#{@config.rss_max}"
  end
end
