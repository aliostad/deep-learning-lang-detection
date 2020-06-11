(ns lotto.core)

(use '[clojure.string :only (join split)])
(import 'java.net.URL
        '(java.io InputStreamReader BufferedReader))

(defn download-page []
  (let [url (URL. "http://www.flalottery.com/exptkt/l6.htm" )]
    (with-open [stream (. url openStream)]
      (let [buf (BufferedReader. (InputStreamReader. stream))]
        (apply str (line-seq buf))))))

(defn get-numbers [str]
  (partition 
    6 (re-seq #"(?<=>)\d+(?=<\/font)" str)))

(defn format-numbers [col]
  (doseq [numbers col] (println (clojure.string/join "-" numbers))))

(defn -main [] 
  (format-numbers (get-numbers (download-page))))
