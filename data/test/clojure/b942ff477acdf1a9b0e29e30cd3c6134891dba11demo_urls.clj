(ns probabilistic-counting.demo-urls
  "Estimate the number of unique domains in the Common crawl dataset"
  (:use [probabilistic-counting.log-log]))

(defn urls-stream
  [url-file]
  (-> url-file
      clojure.java.io/reader
      line-seq))

(defn hosts-stream
  [url-stream]
  (map
   #(first (clojure.string/split % #"/"))
   url-stream))

(defn count-hosts
  [a-hosts-stream]
  (log-log a-hosts-stream 10))

(defn -main
  [& args]
  (let [path     (first args)
        num-urls (when (second args)
                   (-> args second Integer/parseInt))]
    (if num-urls
      (->> path urls-stream hosts-stream (take num-urls) count-hosts)
      (->> path urls-stream hosts-stream count-hosts))))
