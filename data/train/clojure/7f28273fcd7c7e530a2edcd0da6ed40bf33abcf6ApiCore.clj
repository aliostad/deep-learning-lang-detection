(ns metapp.ApiCore
  (:require
            [clojure.java.io :as io]
            [clj-http.client :as client]
            [clojure.string :as string]
            [cheshire.core :as json]
            [clojure.spec :as s]
            [metapp.mathfunc :as mf]
            [clojure.core.async :as async]
            [clojure.spec :as s]
            [clojure.spec.test :as st]))





(def account-number "101-004-5596432-001")
(def auth-bearer "92cf1c65183ace48d00edb9051d4ec47-0ce0dd3c112dba839c9bc6a9ed9d4116")
(def url-root "https://api-fxpractice.oanda.com/v3/")
(def url-stream-root "https://stream-fxpractice.oanda.com/v3/")
(def headers {:headers
                  {"Authorization" (str "Bearer " auth-bearer)
                   "Content-Type" "application/json"
                   "Accept-Datetime-Format" "UNIX"
                   }
              :as :json})






(defn read-body [PersistentArrayMap] (:body PersistentArrayMap))

;ACCOUT ENDPOINTS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(defn get-account-list
  [] (read-body (client/get url-root headers)))

(defn get-details-for-account
  [] (read-body (client/get (str url-root "accounts/" account-number) headers)))

(defn get-summary-account
  [] (read-body (client/get (str url-root "accounts/" account-number "/summary") headers)))

(defn get-instr
  [] (read-body (client/get (str url-root "accounts/" account-number "/instruments") headers)))

;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<






;ORDER ENDPOINTS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

(defn post-order
  "
  Many order specifications are not implemented.
  Check docs https://developer.oanda.com/rest-live-v20/order-df/#MarketOrderRequest
  "
  ([orderMap]
   (let [url (str url-root "accounts/" account-number "/orders")
         body ((json/generate-string orderMap))]
     (client/post url headers {:body body})))) ;vérifier le nombre de parantheses

(s/fdef post-order
        :args (s/cat :orderMap ::MarketOrderRequest
                     ))

(defn close-poz
  "
  Close partially or fully a specific open Trade in an Account
  "
  ([id]
   (let [url (str url-root "accounts/" account-number "/trades/" id "/close")]
     (client/put url headers))))

(defn get-trades []
  (let [url (str url-root "accounts/" account-number "/trades")]
    (client/get url headers)))

(defn get-open-trades []
  (let [url (str url-root "accounts/" account-number "/openTrades")]
    (client/get url headers)))

(defn modify-trade
  "
  Create, replace, cancel a Trade's dependent Orders (TP, SL, TS) through the trade itself
  "
  ([id]
   (let [url (str url-root "accounts/" account-number "/trades/" id "/orders")]
     (client/get url headers))))
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<





;===INSTRUMENT ENDPOINTS===
(defn my-conj [coll x]
  (let [z (assoc x :mid (mf/map-kv read-string (:mid x)))]
    (conj coll z)))
;;(def ar [{:a 15 :b reduce(+,[1,2,3],0){:c "12" :d "15"}} {:a 15 :b {:c "12" :d "15"}} {:a 15 :b {:c "12" :d "15"}}])
;;(reduce my-conj [] ar)
;;[{:a 15, :b {:c 12, :d 15}} {:a 15, :b {:c 12, :d 15}} {:a 15, :b {:c 12, :d 15}}]


(defn fetch-candles
  "Fetch historical data. Cannot use /pricing EP for historical."
  [instr granularity numberOfCandles?]
  (let [url (str url-root "instruments/" instr "/candles?")]
    (let [Candlesticks (:candles (read-body (client/get (str url "granularity=" granularity "&count=" numberOfCandles?) headers)))]
      ;; Array of Candlesticks
      (let [Candlesticks (map #(mf/update-vals % [:time] read-string) Candlesticks)]
        (reduce my-conj [] Candlesticks)
        ))))

(s/fdef fetch-candles
        :args (s/and (s/cat :instr ::InstrumentName
                            :granularity ::CandlestickGranularity
                            :numberOfCandles nat-int?))
        :ret ::Candlestick)




(defn get-pricing [& currencies]
  (let [param (string/join "%2C" [currencies])
        url (str url-root "accounts/" account-number "/pricing?instruments=" param)
        ]
    (read-body (client/get url headers))))
;=== ===



;===POSITION ENDPOINTS===
(defn get-poz []
  (client/get  (str url-root "accounts/" account-number "/positions") headers))


(defn get-openpoz []
  (client/get  (str url-root "accounts/" account-number "/openPositions") headers))

(defn get-openpoz-inst [instr]
  (client/get  (str url-root "accounts/" account-number "/positions/" instr) headers))

;===  ===


;===STREAMING===

(defn get-raw-stream
  "
  Subscribes to a stream of currencies and print them. Need to store it for next processing.
  A vector of currencies.
  Rajouter la gestion d'erreurs...
  "
  [mstate & currencies]
  (async/go
    (let [param (string/join "%2C" currencies) ;"Connection" "Keep-Alive"}}) ;, :as :stream}
          url (str url-stream-root "accounts/" account-number "/pricing/stream?instruments=" param)
          headers (assoc headers :as :stream)] ; assoc RETURN a map, doesn't assoc in-place
      (let [body (:body (client/get url headers))]

        (dosync (ref-set mstate (mf/map-mult-keys @mstate currencies)))
        ;(println @mstate currencies)
        ;(println "ref setted")
        (when (-> body nil? not)
          (let [rd (io/reader body)]
            (assoc mstate nil

                          (while true
                            (let [rep (json/parse-string (.readLine rd))]
                              ;(println "before calling update")
                              ;(update-state rep)
                              )))))))))
;===  ===

;=== CREATE ORDERS

(defn create-MOR [units instrument timeInForce & optionalMap]
  (let [answ {:type "MARKET" :units units :instrument instrument :timeInForce timeInForce
              :positionFill "DEFAULT"}]
    (merge  answ optionalMap)))                            ;;d'abord default, ensuite optionalMap

(defn create-LOR [units instrument timeInForce  price triggerCondition optionalMap]
  ((let [answ {:type "LIMIT" :units units :instrument instrument :timeInForce timeInForce
                 :positionFill "DEFAULT" :price price :triggerCondition triggerCondition}]
       (merge answ optionalMap))))

(defn create-TPOR [tradeID price timeInForce triggerCondition optionalMap]
  ((let [answ {:type "TAKE_PROFIT" :timeInForce timeInForce
                :price price :triggerCondition triggerCondition}]
     (merge answ optionalMap))))

(defn create-SLOR [tradeID price timeInForce triggerCondition optionalMap]
  ((let [answ {:type "STOP_LOSS" :timeInForce timeInForce
               :price price :triggerCondition triggerCondition}]
     (merge answ optionalMap))))
