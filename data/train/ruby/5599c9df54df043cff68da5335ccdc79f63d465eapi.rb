module Bcash::Api
  autoload :Accounts, 'bcash/api/accounts'
  autoload :VerifyReturn, 'bcash/api/verify_return'
  autoload :FindTransaction, 'bcash/api/find_transaction'

  autoload :Response, 'bcash/api/response'
  autoload :AccountResponse, 'bcash/api/account_response'
  autoload :CreateAccountResponse, 'bcash/api/create_account_response'
  autoload :AccountNotValidResponse, 'bcash/api/account_not_valid_response'
  autoload :VerifyReturnResponse, 'bcash/api/verify_return_response'
  autoload :TransactionResponse, 'bcash/api/transaction_response'

  autoload :BaseRequest, 'bcash/api/request/base_request'
  autoload :AddressRequest, 'bcash/api/request/address_request'
  autoload :AccountCreationRequest, 'bcash/api/request/account_creation_request'
  autoload :ContactRequest, 'bcash/api/request/contact_request'
  autoload :PersonRequest, 'bcash/api/request/person_request'
end
