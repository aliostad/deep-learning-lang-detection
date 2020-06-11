module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  protected

  def generate_token
    self.token = loop do
      random_token = (chunk('a'..'z') + '-' +
                      chunk('0'..'9') + '-' +
                      chunk('a'..'z') + '-' +
                      chunk('0'..'9') + '-' +
                      chunk('a'..'z'))

      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def chunk(range)
    range.to_a.shuffle[0,3].join.upcase
  end
end
