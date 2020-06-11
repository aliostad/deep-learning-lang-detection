module ActsAsNestedInterval
  module Calculate
    extend ActiveSupport::Concern

    included do
      if columns.map(&:name).include?("depth")
        calculate :depth
      else
        alias :depth :calculate_depth
      end
    end

    def calculate_depth
      if new_record?
        parent.present? ? parent.depth + 1 : 0
      else
        n = 0
        p, q = lftp, lftq
        while p != 0
          x = p.inverse(q)
          p, q = (x * p - 1) / q, x
          n += 1
        end
        return n
      end
    end

    def calculate_lft; 1.0 * lftp / lftq end
    def calculate_rgt; 1.0 * rgtp / rgtq end

    # Returns numerator of right end of interval.
    def calculate_rgtp
      case lftp
      when 0 then 1
      when 1 then 1
      else lftq.inverse(lftp)
      end
    end

    # Returns denominator of right end of interval.
    def calculate_rgtq
      case lftp
      when 0 then 1
      when 1 then lftq - 1
      else (lftq.inverse(lftp) * lftq - 1) / lftp
      end
    end

    module ClassMethods
      def calculate(*methods)
        methods.each do |method|
          define_method method do
            attributes[method.to_s] || send( :"#{ method }=", send(:"calculate_#{ method }") )
          end
        end
      end
    end
  end
end
