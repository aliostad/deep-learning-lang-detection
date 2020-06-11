(ns btc-market.events
  (:require [btc-market.db :as db ]
            [clojure.spec.alpha :as s]
            [re-frame.core :refer [after dispatch reg-event-db reg-event-fx reg-fx]]
            [cljsjs.socket-io]
            [clojure.string :as str]
            [btc-market.common :refer [crypto-utils]]
            [btc-market.common :refer [retrieve]]
            [btc-market.common :refer [save]]
            [btc-market.common :refer [retrieve]]
            [btc-market.common :refer [socket-io]]
            [btc-market.trading :refer [buy-sell-view]]
            [btc-market.common :as c]
            [btc-market.prices :refer [dashboard-view]]))

(def btc-url "https://api.btcmarkets.net")
(def ROUND_NUM 100000000)

;; initialn state of app-db
(def app-db {:active-instrument "BTC"})

(def fetch (.-fetch js/window))
(defn json [data] (-> (.-JSON js/window) (.parse data) js->clj))
;; -- Interceptors ------------------------------------------------------------
;;
;; See https://github.com/Day8/re-frame/blob/master/docs/Interceptors.md
;;
(defn check-and-throw
  "Throw an exception if db doesn't have a valid spec."
  [spec db [event]]
  (when-not (s/valid? spec db)
    (let [explain-data (s/explain-data spec db)]
      (throw (ex-info (str "Spec check after " event " failed: " explain-data) explain-data)))))

(def validate-spec
  (if goog.DEBUG
    (after (partial check-and-throw ::db/app-db))
    []))

;; -- FX handlers -----------------------------------------------------------



(defn http-fetch [{:keys [url method body headers success failure]}]
  (-> (fetch url #js {:method (or (some-> method name)  "get")
                      :headers (clj->js headers)
                      :body body
                      :guard "immutable"})
      (.then #(if (.-ok %) (.json %)
                  (throw (.text %))))
      (.then #(as-> % data (js->clj data :keywordize-keys true)
                    (if (not= false (:success data)) (success data) (failure data))))
      (.catch failure)))

(reg-fx
 :http
 (fn [req]
   (doall (for [{:keys [url method success failure]} (if (map? req) [req] req)
                :let [[evt rfn & more] success]]
            (http-fetch {:url url :success #(dispatch (vec (concat [evt (rfn %)] more)))
                         :failure #(dispatch (vec (conj failure %)))})))))

(reg-fx
 :http-with-hmac
 (fn [req]
   (doall (for [{:keys [url path method body success failure headers key secret]}
                (if (map? req) [req] req)
                :let [[evt rfn & more] success]]
            (let [timestamp (js/Date.now)
                  body-str (some-> body clj->js js/JSON.stringify)]
              (js/console.log "timestamp:" timestamp "key" key "body:" body-str)
              (.hmac crypto-utils secret (str path "\n" timestamp "\n" body-str)
                     (fn [signature]
                       (http-fetch {:url (str url path)
                                    :method method
                                    :body body-str
                                    :headers {"Accept" "application/json"
                                              "Accept-Charset" "UTF-8"
                                              "Content-Type" "application/json"
                                              "apikey" key
                                              "timestamp" timestamp
                                              "signature" signature}
                                    :success #(dispatch (vec (concat [evt (rfn %)] more)))
                                    :failure #(dispatch (vec (conj failure %)))}))))))))

(reg-fx
 :setup-websocket
 (fn setup-websocket []
   (let [socket (socket-io "https://socket.btcmarkets.net"
                           #js {"secure" true "transports" #js ["websocket"]
                                "upgrade" false})]
     (doto socket
       (.on "connect" #(dispatch [:ws-connected socket]))
       (.on "newTicker" #(dispatch [:new-ticker (js->clj % :keywordize-keys true) ROUND_NUM]))
       (.on "disconnect" #(dispatch [:ws-closed %]))))))

(reg-fx
 :dispatch-interval
 (fn [[evt interval]]
   (js/setInterval #(dispatch evt) interval)))

(reg-fx
 :read-store
 (fn [[key success-event fail-event]]
   (retrieve key #(dispatch (conj success-event %)) #(dispatch (conj fail-event %)))))

(reg-fx
 :write-store
 (fn [[key value]]
   (if value (save key value))))

(reg-fx
 :join-ticker-channel
 (fn [[socket instrument]]
   (.emit socket "join" (str "Ticker-BTCMarkets-" instrument "-AUD"))))
;; -- Handlers --------------------------------------------------------------

(reg-event-fx
 :initialize-db
 validate-spec
 (fn [_ _]
   {:db app-db
    :dispatch [:push-view #'dashboard-view] ;;[:fetch-prices (:active-instrument app-db)]
    :read-store [:config [:update-config] [:log]]
    :setup-websocket nil}))

(reg-event-fx
 :ws-connected
 (fn [{:keys[db]} [_ socket]]
   {:db (assoc db :socket socket)
    :dispatch [:join-channel]}))

(reg-event-db
 :join-channel
 validate-spec
 (fn [db [_]]
   (let [socket (:socket db)]
     (doseq [instrument (:active-instrument db)]
       (.emit socket "join" (str "Ticker-BTCMarkets-" (str instrument "-AUD")))))
   db))

(reg-event-db
 :new-ticker
 validate-spec
 (fn [db [_ ticker scale]]
   (let [{:keys [instrument currency lastPrice bestBid bestAsk]} ticker]
     (update db :market-data assoc instrument
             {:instrument instrument
              :price (/ lastPrice scale)
              :bid (/ bestBid scale)
              :ask (/ bestAsk scale)}))))

(reg-event-db
 :ws-closed
 validate-spec
 (fn [db [_]]
   (dissoc db :socket)))

(reg-event-fx
 :set-active-instrument
 validate-spec
 (fn [{:keys [db]} [_ new-instrument]]
   {:db (assoc db :active-instrument new-instrument)
    :dispatch-n [[:fetch-prices new-instrument] [:fetch-open-orders new-instrument]]
    :join-ticker-channel [(:socket db) new-instrument]}))

;; (reg-event-db)
(reg-event-fx
 :fetch-prices
 validate-spec
 (fn [world [_ instrument]]
   {:db (:db world)
    :http (for [curpair (or (some-> instrument (str "/AUD") vector) (:active-instrument (:db world)))]
            {:url (str btc-url "/market/" curpair "/tick")
             :success [:new-ticker identity 1]
             :failure [:log curpair]})}))

(reg-event-fx
 :fetch-account-balance
 validate-spec
 (fn [{:keys [db]} [_]]
   {:db db
    :http-with-hmac {:url btc-url :path "/account/balance"
                     :key (-> db :config :api-key)
                     :secret (-> db :config :api-secret)
                     :failure [:log]
                     :success [:account-updated identity]}}))

(reg-event-db
 :account-updated
 validate-spec
 (fn [db [_ balances]]
   (update db :account assoc
           :balances (for [bal balances :when (pos? (:balance bal))]
                       (-> bal (update :balance / ROUND_NUM))))))

(reg-event-db
 :log
 (fn [db [_ value & more]]
   (js/console.log "log:" value more)
   (c/alert "Error" (:errorMessage value))
   db))

(reg-event-db
 :push-view
 validate-spec
 (fn [db [_ view & more]]
   (update db :view-stack #(cons [view more] %))))

(reg-event-db
 :pop-view
 validate-spec
 (fn [db [_]]
   (update db :view-stack rest)))

(reg-event-fx
 :update-config
 validate-spec
 (fn [{:keys [db]} [_ config]]
   {:db (assoc db :config config)
    :write-store [:config config]}))

(reg-event-fx
 :fetch-open-orders
 validate-spec
 (fn [{:keys [db]} [_ instrument]]
   {:db db
    :http-with-hmac
    {:url btc-url :path "/order/open"
     :method :post
     :body  {:currency "AUD" :instrument (or instrument (:active-instrument db)) :limit 10 :since 1}
     :key (-> db :config :api-key)
     :secret (-> db :config :api-secret)
     :failure [:log]
     :success [:orders-retrieved identity]}}))

(reg-event-db
 :orders-retrieved
 validate-spec
 (fn [db [_ response]]
   (assoc db :orders (for [ord (:orders response)]
                       (reduce #(update %1 %2 / ROUND_NUM) ord [:volume :price :openVolume])))))

(reg-event-fx
 :exec-order
 validate-spec
 (fn [{:keys[db]} [_ new-order]]
   {:db db
    :http-with-hmac
    {:url btc-url :path "/order/create"
     :method :post
     :body (-> new-order
               (assoc :currency "AUD" :clientRequestId (str "ord-" (js/Date.now)))
               (update :price * ROUND_NUM)
               (update :volume * ROUND_NUM)
               (select-keys [:currency :instrument :price :volume :orderSide
                             :ordertype :clientRequestId]))
     :key (-> db :config :api-key)
     :secret (-> db :config :api-secret)
     :failure [:log]
     :success [:pop-view identity]}}))

(reg-event-fx
 :cancel-order
 validate-spec
 (fn [{:keys[db]} [_ id]]
   {:db db
    :http-with-hmac
    {:url btc-url :path "/order/cancel"
     :method :post
     :body {:orderIds [id]}
     :key (-> db :config :api-key)
     :secret (-> db :config :api-secret)
     :failure [:log]
     :success [:fetch-open-orders]}}))
