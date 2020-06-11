(ns cosm-overtone.core
  (:use overtone.live)
  (:require [clj-http.client :as client]))

(defn- put-cosm
  "Update cosm feed"
  [stream_id value]
  (if-not (empty? value) (client/put (str "http://api.cosm.com/v2/feeds/80428.csv") {:headers {"X-ApiKey" "MBhfc52ZUaa-DGD3cFtgcB1bmtSSAKwwWmRPR0RjRkJnND0g"} :body (str stream_id "," value) :throw-exceptions false})))

(defn- handle-input
  "Parse input and send to cosm"
  [msg]
  (let [instrument (get msg :path)
        args (get msg :args)]
    (put-cosm (clojure.string/replace (str instrument) #"/" "") (clojure.string/replace (str args) #"[()]" ""))))

(defn -main
  "Called by lein run"
  [& args]
  (osc-listen (osc-server 44100 "osc-clj") (fn [msg] (handle-input msg))))
