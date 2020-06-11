module Mundipagg
  class Refund < ActiveMerchant::Billing::Model
    attr_accessor :transaction_key, :order_key

    def payload(amount)
      {
        manage_credit_card_transaction_collection: {
          manage_credit_card_transaction_request: {
            amount_in_cents: amount,
            transaction_key: transaction_key
          }
        },
        manage_order_operation_enum: "Void",
        order_key: order_key
      }
    end

    class Response < Mundipagg::Response
      def payload
        body[:manage_order_response][:manage_order_result]
      end

      def error_item
        payload[:error_report][:error_item_collection][:error_item]
      end
    end
  end
end
