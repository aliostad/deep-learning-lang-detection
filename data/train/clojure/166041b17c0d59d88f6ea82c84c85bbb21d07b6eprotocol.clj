(ns hello-world.protocol
  (:require
   [schema.core :as s]
   ))

(def trade-manager-dispatch-values
  {:in :trade-manager/in
   :out :trade-manager/out
   :market-book :trade-manager/market-book})

(def TradeManagerDispatchSchema
  (apply s/enum (vals trade-manager-dispatch-values)))

(def TradeManagerMsg
  {:dispatch TradeManagerDispatchSchema
   :msg s/Any})

(def betfair-client-dispatch-values
  {:account :account/request
   :betting :betting/request
   :market-book :betting/market-book
   })

(def BetfairClientDispatchSchema
  (apply s/enum (vals betfair-client-dispatch-values)))

(def BetfairClientMsg
  {:dispatch BetfairClientDispatchSchema
   :endpoint s/Any
   :body s/Any})
