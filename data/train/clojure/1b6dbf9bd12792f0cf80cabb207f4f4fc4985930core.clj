(ns zap-router.core
  (:require [aleph.tcp :as tcp]
            [clojure.core.async :as a]
            [manifold.stream :as s])
  (:import [zaprouter Connection]))

(def config (atom {:players {}}))

(defn register-response [player-id]
  (-> (zaprouter.Connection$RegisterResponse/newBuilder)
      (.setClientId player-id)
      (.setSuccess true)
      (.build)))

(defn- register! [player stream main-stream]
  (println "Registering player" player "with stream" stream)
  (let [{:keys [players]} (swap! config #(update-in % [:players] assoc player stream))]
    (when (= 2 (count players))
      (println "Players registered")
      (s/put! main-stream {:client "player1" :msg (register-response "player1")})
      (s/put! main-stream {:client "player2" :msg (register-response "player2")}))))

(defn echo-handler [player-id main-stream player-stream info]
  (register! (keyword (str "player" (swap! player-id inc))) player-stream main-stream)
  (s/connect player-stream main-stream))

(defn run [port]
  (let [player-id (atom 0)
        main-stream (s/stream)
        server (tcp/start-server (partial echo-handler player-id main-stream) {:port port})]
    (println "ZapRouter Running")
    (a/go-loop []
               (try
                 (let [{:keys [client msg]} @(s/take! main-stream)]
                   (println "Got input for" client "with msg" (.toString msg))
                   (doseq [[player output-stream] (:players @config)]
                     (when (= (name player) client)
                       (println "Sending to" client)
                       @(s/put! output-stream (.toByteArray msg)))))
                 (catch Exception e
                   (println "Exception" e)))
               (recur))
    server))

(defn -main [& args]
  (let [signal (java.util.concurrent.CountDownLatch. 1)]
    (run 10001)
    (.await signal)))

 ;     (.close (tcp/start-server (partial echo-handler :player1 :player2 (s/stream)) {:port 10004}))
