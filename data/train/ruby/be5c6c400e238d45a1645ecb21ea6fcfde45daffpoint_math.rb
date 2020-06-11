class PointMath

  attr_accessor :topic_xys

  def initialize(topics)
    @topics = topics
    @center = SvgCenter.new(@topics).largest_topic
    @topic_xys = {}
    calculate_topic_xys
  end

private

  def number_of_topics
    @topics.size
  end

  def calculate_topic_angle(i)
    i * 2 * Math::PI / number_of_topics
  end

  def calculate_x(t, topic_angle)
    Math.cos(topic_angle) * t.votes.size + @center
  end

  def calculate_y(t, topic_angle)
    Math.sin(topic_angle) * t.votes.size + @center
  end

  def calculate_topic_xys
    @topics.each_with_index do |t, i|
      topic_angle = calculate_topic_angle(i)
      @topic_xys[t] = {
        x: calculate_x(t, topic_angle),
        y: calculate_y(t, topic_angle)
      }
    end
  end
end