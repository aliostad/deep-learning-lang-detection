(ns chunktest.core
  (:use [aleph.http :only [start-http-server wrap-ring-handler]]
        [lamina.core :only [channel close enqueue]]
        [clojure.java.io :only [file]])
  (:import (java.io BufferedReader FileInputStream)))

(defn stream-stuff [ch]
  (future
    (with-open [stream (FileInputStream. (file "/Users/hinmanm/test.txt"))]
      (loop []
        (let [c (.read stream)]
          (println :c c)
          (if (pos? c)
            (do
              (enqueue ch (str (char c)))
              (recur))
            (println :bailing)))))
    (println :closing)
    (close ch)
    (println :closed)))

(defn handler [request]
  (let [stream (channel)]
    (stream-stuff stream)
    {:status 200
     :headers {"content-type" "text/plain"}
     :body stream}))

(defn start [] (start-http-server (wrap-ring-handler handler) {:port 8080}))
