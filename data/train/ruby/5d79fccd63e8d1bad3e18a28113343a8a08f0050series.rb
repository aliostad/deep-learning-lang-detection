require "pp"

module TimeSeries
  class Series < TimeSeriesSprite
  
    attr_accessor :name, :points, :color
  
    def initialize name, points, opts={}
      super(opts)
      self.name = name
      self.points = points
      self.color = opts[:color]

      on_render do |ctx|
        ctx.set_line_width(1)
        ctx.set_source_color(color)
        ctx.stroke_preserve 
        ctx.move_to(calculate_x(points.first[0]), calculate_y(points.first[1]))
        points.each do |point|
          ctx.line_to(calculate_x(point[0]), calculate_y(point[1]))
        end
        ctx.stroke
      end
    end
        
  end
end