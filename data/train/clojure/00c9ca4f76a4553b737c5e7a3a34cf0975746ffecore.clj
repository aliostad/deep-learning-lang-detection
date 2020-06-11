(ns rdcp.core
  (:require [clojure.string :as str]
            [aleph.tcp :as tcp]
            [manifold.stream :as s]
            [byte-streams :as b]))

(defn send-rdcp! [stream val] (s/put! stream (str val "\n")))

(defn get-client-stream [team-name & [{:keys [host port]}]]
  (let [client (tcp/client {:host host :port port})
        msg (b/to-string @(s/take! @client))]
    (send-rdcp! @client team-name)
    @client))

(defn parse-dir [val]
  [(keyword (str (first val))) (read-string (str (second val)))])

(defn parse-response [response]
  (into {} (map parse-dir ((comp #(str/split % #"\s+") str/trim) response))))

(defn decode-rdcp [byte-buffer]
  (let [resp (b/to-string byte-buffer)]
    (when (= \N (first resp))
      (parse-response resp))))

(def right-wall
  {:N [:W :N :E :S]
   :E [:N :E :S :W]
   :S [:E :S :W :N]
   :W [:S :W :N :E]})

(def left-wall
  {:N [:W :S :E :N]
   :E [:N :W :S :E]
   :S [:E :N :W :S]
   :W [:S :E :N :W]})

(defn wall-follow [curr-dir {:keys [P] :as curr-pos} ]
  (if-let [present-dir (#{:N :E :S :W :X} (keyword P))]
    present-dir
    (->> (get right-wall curr-dir)
         (map #(when (> (get curr-pos %) 0) %))
         (remove nil?)
         (first))))

(defn move-handler [stream timeout]
  (let [!curr-dir (atom :N) !curr-pos (atom nil)]
    (fn [byte-buffer]
      (when-let [r (decode-rdcp byte-buffer)]
        (reset! !curr-pos r)
        (let [dir (wall-follow @!curr-dir @!curr-pos)]
          (reset! !curr-dir dir)
          (when (not= dir :X)
            (send-rdcp! stream (name dir))))
        (Thread/sleep timeout)))))

;; -----------------------------------------------------------------------------

(comment
  (def stream (get-client-stream "Manifold"
                                 {:host "localhost" :port 8080}))

  (s/consume (move-handler stream 50) stream)

  (.close stream)

  (defn move! [stream dir] (send-rdcp! stream (name dir)))

  (move! stream :N)
  (move! stream :S)
  (move! stream :E)
  (move! stream :W)

  (parse-response "N5 E0 S1 W0 P?")
  ;; => {:N 5, :E 0, :S 1, :W 0, :P '?}

  (wall-follow :N {:N 2, :E 0, :S 2, :W 2, :P '?})
  ;; => :W
  )
