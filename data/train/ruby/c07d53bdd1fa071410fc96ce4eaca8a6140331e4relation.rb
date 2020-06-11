module LazyDataApi
  class Relation < ActiveRecord::Base
    self.table_name_prefix = 'lazy_data_api_'
    self.primary_key = 'api_id'

    attr_accessible :api_id

    belongs_to :apiable, polymorphic: true

    validates :api_id, presence: true, uniqueness: true

    after_initialize :generate_api_id, unless: :api_id

    def generate_api_id
      self.api_id = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        unless ::LazyDataApi::Relation.exists?(api_id: random_token)
          break random_token
        end
      end
    end
  end
end
