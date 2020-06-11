module Dao
  class << Api
    def evaluate(&block)
      @dsl ||= DSL.new(api=self)
      @dsl.evaluate(&block)
    end
  end

  class Api
    class DSL < BlankSlate
      attr_accessor :api

      def initialize(api)
        @api = api
        @evaluate = Object.instance_method(:instance_eval).bind(self)
      end

      def evaluate(&block)
        @evaluate.call(&block)
      end

      def endpoint(*args, &block)
        api.endpoint(*args, &block)
      end

      def Endpoint(*args, &block)
        api.Endpoint(*args, &block)
      end

      def path(path)
        api.path = path.to_s
      end
    end
  end

  def Dao.api(&block)
    if block
      api = Class.new(Api)
      api.evaluate(&block)
      api
    else
      Api
    end
  end
end

