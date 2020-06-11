module Items
  class Create
    attr_accessor :attrs, :items_repository, :categories_repository

    def initialize(attrs, items_repository = nil, categories_repository = nil)
      self.attrs = attrs
      self.items_repository = items_repository || ItemsRepository.new
      self.categories_repository = categories_repository ||
        CategoriesRepository.new
    end

    def call
      attrs[:start_date] ||= Date.today
      item = items_repository.add attrs
      if item.valid?
        Response::Success.new(data: item)
      else
        Response::Error.new(errors: item.errors.full_messages)
      end
    end
  end
end
