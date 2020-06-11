(ns clirj.net
  (:require [cljs-http.client :as http]
            [re-frame.core :as rf]
            [cljs.core.async :refer [<! put! chan]])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(def request-types {:get    http/get
                    :put    http/put
                    :patch  http/patch
                    :post   http/post
                    :delete http/delete})
(defn make-request
  [req-type url & [channel]]
  (go
    (let [response (<! ((req-type request-types) url {:with-credentials? false}))]
      (when channel
        (put! channel (:body response))))))

(defn list-members
  [channel]
  (make-request :get "http://localhost:8080/list" channel))

(defn ban-member
  [user]
  (make-request :get (str "http://localhost:8080/disconnect/" user)))

(defn make-websocket
  [name]
  (let [ws (js/WebSocket. (str "ws://localhost:8080/connect/" name))
        get-chan (chan)]

    (set! (.-onopen ws) (fn []
                          (prn "Connection open")
                          (list-members get-chan)
                          (go
                            (rf/dispatch [:manage-members (set (<! get-chan))]))
                          (rf/dispatch [:web-socket ws])))
    (set! (.-onclose ws) (fn []
                           (prn "Connection closed")
                           (rf/dispatch [:manage-members #{}])
                           (rf/dispatch [:web-socket nil])))
    (set! (.-onmessage ws) #(let [event-data (cljs.reader/read-string (.-data %))
                                  event-type (-> (keys event-data) first)]
                              (when event-type
                                (rf/dispatch [event-type (get event-data event-type)]))))))
