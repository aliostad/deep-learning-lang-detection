(ns tycoon-server.core
  (:require [aleph.tcp :as tcp]
            [manifold.stream :as s]
            [manifold.deferred :as d]
            [manifold.bus :as bus]
            [tycoon-server.levels :as levels]))


(defn sputln! [stream x]
  (s/put! stream (str (clojure.string/trim-newline x) "\n")))

(defn handler [stream info]
  (d/loop []
    (-> (s/take! stream ::none)
        (d/chain
         (fn [msg]
           (if (= ::none msg)
             ::none
             (d/future (levels/read (String. msg)))))
         (fn [the-map]
           (when-not (= ::none the-map)
             (sputln! stream the-map)))
         (fn [result]
           (when result (d/recur))))

        (d/catch
            (fn [e]
              (s/put! stream (str "ERROR: " e))
              (s/close! stream))))))

(defn -main [& args]
  (let [port (Integer/parseInt (or (first args) "8080"))]
    (println "Starting on port" port)
    (tcp/start-server #'handler {:port port})))
