# TODO: Organize requires
require 'typhoeus'
require 'hashie'
require 'rash'
require 'addressable/uri'

require 'korbit_api/resources/bid'
require 'korbit_api/resources/constant'
require 'korbit_api/resources/fiat_address'
require 'korbit_api/resources/orderbook'
require 'korbit_api/resources/status'
require 'korbit_api/resources/transaction'

require 'korbit_api/utils'


require 'korbit_api/coins'
require 'korbit_api/constants'
require 'korbit_api/crypto_address'
require 'korbit_api/error'
require 'korbit_api/fiats'
require 'korbit_api/market'
require 'korbit_api/order'
require 'korbit_api/orderbook'
require 'korbit_api/orders'
require 'korbit_api/ticker'
require 'korbit_api/transactions'
require 'korbit_api/transfer'
require 'korbit_api/transfer_status'
require 'korbit_api/user'

require 'korbit_api/version'
require 'korbit_api/wallet'

require 'korbit_api/client'

module KorbitAPI
  class << self
    def configure
      yield config
    end

    def config
      @config ||= OpenStruct.new
    end
  end
end