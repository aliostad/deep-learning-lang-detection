(ns metapp.specs.Order
  (:require
    [clojure.spec :as s]
    [clojure.spec.test :as st])
  )
;;namespace introuvable!

(s/def ::OderPositionFill #{"OPEN_ONLY" "REDUCE_FIRST" "REDUCE_ONLY" "DEFAULT"})
(s/def ::OrderTriggerCondition #{ "DEFAULT" "INVERSE" "BID" "ASK" "MID"})
(s/def ::OrderType #{"MARKET" "LIMIT" "STOP" "MARKET_IF_TOUCHED" "TAKE_PROFIT" "STOP_LOSS" "TRAILING_STOP_LOSS"})
(s/def ::TimeInForce #{"GTC" "GTD" "GFD" "FOK" "IOC"})
(s/def ::OrderState #{"PENDING" "FILLED" "TRIGGERED" "CANCELLED"})
(s/def ::clientOrderID ::ClientID)
(s/def ::OrderIdentifier (s/keys :req [::orderID ::clientOrderID]))
(s/def ::orderID ::OrderID)
(s/def ::timeInForce ::TimeInForce)
;"GTC" “Good unTil Cancelled”
;"GTD" “Good unTil Date”
;"GFD" “Good For Day”
;"FOK" “Filled Or Killed”
;"IOC" “Immediatedly paritally filled Or Cancelled”

(s/def ::positionFill ::OderPositionFill)
;;"OPEN_ONLY"  When the Order is filled, only allow Positions to be opened or extended.
;;"REDUCE_FIRST"  When the Order is filled, always fully reduce an existing Position before opening a nsssew Position.
;;"REDUCE_ONLY"  	When the Order is filled, only reduce an existing Position.
;;"DEFAULT"  When the Order is filled, use REDUCE_FIRST behaviour for non-client hedging Accounts, and OPEN_ONLY behaviour for client hedging Accounts.

(s/def ::triggerCondition ::OrderTriggerCondition)
;;"DEFAULT" Trigger an Order the “natural” way: compare its price to the ask for long Orders and bid for short Orders.
;;"INVERSE" Trigger an Order the opposite of the “natural” way: compare its price the bid for long Orders and ask for short Orders.
;;"BID" Trigger an Order by comparing its price to the bid regardless of whether it is long or short.
;;"ASK" Trigger an Order by comparing its price to the ask regardless of whether it is long or short.
;;"MID" Trigger an Order by comparing its price to the midpoint regardless of whether it is long or short.

;OrderRequests
(s/def ::MarketOrderRequest
  (s/keys :req
          [::type
           ::units
           ::instrument
           ::timeInForce
           ::positionFill]
          :opt
          [::priceBound
           ::positionFill
           ::clientExtensions
           ::takeProfitOnFill
           ::stopLossOnFill
           ::trailingStopLossOnFill
           ::tradeClientExtensions]))

(s/def ::LimitOrderRequest
  (s/keys :req
          [::type ;; Must be set to LIMIT
           ::instrument
           ::units
           ::timeInForce
           ::price
           ::positionFill
           ::triggerCondition]

          :opt
          [::gtdTime
           ::clientExtensions
           ::takeProfitOnFill
           ::stopLossOnFill
           ::stopLossOnFill
           ::trailingStopLossOnFill
           ::tradeClientExtensions]))

(s/def ::TakeProfitOrderRequest
  (s/keys :req
          [::type  ;;Must be set to TAKE_PROFIT
           ::tradeID
           ::price
           ::timeInForce
           ::triggerCondition]
          :opt
          [::clientTradeID
           ::gtdTime
           ::clientExtensions]))

(s/def ::StopLossOrderRequest
  (s/keys :req
          [::type
           ::tradeID
           ::price
           ::timeInForce
           ::triggerCondition]
          :opt
          [::clientTradeID
           ::gtdTime
           ::clientExtensions]))


(s/def ::StopOrderRequest
  (s/keys :req
          [::type
           ::instrument
           ::units
           ::price
           ::timeInForce
           ::positionFill
           ::triggerCondition]

          :opt
          [::tradeClientExtensions
           ::priceBound
           ::stopLossOnFill
           ::trailingStopLossOnFill
           ::takeProfitOnFill
           ::gtdTime]))

(s/def ::MarketOrderTransaction
  (s/keys :req
          [::instrument
           ::units
           ::timeInForce
           ::positionFill]
          :opt
          [::id
           ::time
           ::userID
           ::accountID
           ::batchID
           ::requestID
           ::type                                           ;; attention c'est pas le même type partout!
           ::priceBound
           ::tradeClose
           ::longPositionCloseout
           ::shortPositionCloseout
           ::marginCloseout
           ::delayedTradeClose
           ::reason
           ::clientExtensions
           ::takeProfitOnFill
           ::stopLossOnFill
           ::trailingStopLossOnFill
           ::tradeClientExtensions]))

