require 'finacle_api/bal_inq/api'
require 'finacle_api/block_modify/api'
require 'finacle_api/xfer_trn_add/api'
require 'finacle_api/stop_chk_add/api'
require 'finacle_api/de_duplication_inq/api'
require 'finacle_api/customer_details/api'


# add your api call functions here

module FinacleApi
  module Callable
    include FinacleApi::BalInq::API
    include FinacleApi::BlockModify::API
    include FinacleApi::XferTrnAdd::API
    include FinacleApi::StopChkAdd::API
    include FinacleApi::DeDuplicationInq::API
    include FinacleApi::CustomerDetails::API
  end
end