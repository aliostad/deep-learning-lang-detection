require 'uphold/api/auth_token'
require 'uphold/api/card'
require 'uphold/api/contact'
require 'uphold/api/endpoints'
require 'uphold/api/private_transaction'
require 'uphold/api/public_transaction'
require 'uphold/api/ticker'
require 'uphold/api/transparency'
require 'uphold/api/user'

module Uphold
  module API
    include API::AuthToken
    include API::Card
    include API::Contact
    include API::PrivateTransaction
    include API::PublicTransaction
    include API::Ticker
    include API::Transparency
    include API::User
  end
end
