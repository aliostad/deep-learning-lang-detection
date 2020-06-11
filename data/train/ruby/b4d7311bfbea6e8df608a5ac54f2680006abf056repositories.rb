module FruitOrcharding
  class Repositories
    @repositories = {}

    class << self
      def configure(&block)
        block.call(self)
      end

      def register_repository(fruit_type, repository)
        @repositories[fruit_type.to_sym] = repository
      end

      def get_repository(fruit_type)
        @repositories[fruit_type.to_sym] or raise "#{fruit_type} repository is not registered"
      end
    end

    # adding some repository manipulation sugar
    class << self
      def method_missing(method, *args, &block)
        repository_get_method?(method) do |fruit_type|
          return get_repository(fruit_type)
        end
        repository_register_method?(method) do |fruit_type|
          return register_repository(fruit_type, *args)
        end
        super(method, args, block)
      end

      def respond_to_missing?(method, *)
        repository_get_method?(method) || repository_register_method?(method) || super
      end

      def repository_register_method?(method, &block)
        repository_method? method, :register, &block
      end

      def repository_get_method?(method, &block)
        repository_method? method, :get, &block
      end

      def repository_method?(method, prefix, &block)
        if method.to_s =~ /#{prefix}_(.*)_repository/
          return $1 unless block_given?
          yield $1
        end
      end
    end
  end
end
