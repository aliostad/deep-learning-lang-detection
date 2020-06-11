Dir[Rails.root.join('spec/support/requests/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Requests::Api::V1::OauthHelper, type: :request
  config.include Requests::Api::V1::JsonHelper, tag: :api

  config.include Requests::Api::V1::SerializedHash::Category, tag: :api
  config.include Requests::Api::V1::SerializedHash::Comment, tag: :api
  config.include Requests::Api::V1::SerializedHash::Policy, tag: :api
  config.include Requests::Api::V1::SerializedHash::Profile, tag: :api
  config.include Requests::Api::V1::SerializedHash::Tag, tag: :api
end
