(ns feet-wet-streams
  (:require [cljs.core.async :refer [<! chan take! tap to-chan] :as async]
            [cljs.nodejs :as node])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

(defn listen [c listener]
  (go-loop [value (<! c)]
    (when value
      (listener value)
      (recur (<! c)))))

(defn single-stream []
  (let [stream (to-chan [1 2 3 4 5])]
    (listen stream #(println "Received" %))))

(defn stream-properties []
  (let [stream (to-chan [1 2 3 4 5])]
    (take! stream #(println "stream first item:" %)))
  (let [stream (to-chan [1 2 3 4 5])]
    (go (println "stream last item: " (last (<! (async/into [] stream))))))
  (let [stream (to-chan [1 2 3 4 5])]
    (go (println "stream empty?: " (empty? (<! (async/into [] stream))))))
  (let [stream (to-chan [1 2 3 4 5])]
    (go (println "stream length: " (count (<! (async/into [] stream)))))))

(defn broadcast []
  (let [stream (to-chan [1 2 3 4 5])
        broadcast-stream (async/mult stream)]
    (let [ev-stream (tap broadcast-stream (chan))]
      (listen ev-stream #(println "broadcast stream listen:" %)))
    (take! (tap broadcast-stream (chan (async/dropping-buffer 1)))
           #(println "broadcast stream first item: " %))
    (go (println "broadcast stream last item: " (last (<! (async/into [] (tap broadcast-stream (chan))))))) 
    (go (println "broadcast stream empty?: " (empty? (<! (async/into [] (tap broadcast-stream (chan (async/dropping-buffer 1)))))))) 
    (go (println "broadcast stream length: " (count (<! (async/into [] (tap broadcast-stream (chan)))))))))

(defn my-drop [n ch]
  (let [out (chan)]
    (go
      (loop [x 0
             v (<! ch)]
        (when (not (nil? v))
          (when (>= x n)
            (>! out v))
          (recur (inc x) (<! ch))))
      (async/close! out))
    out))

(defn my-drop-while [pred ch]
  (let [out (chan)]
    (go
      (loop [dropping? true
             v (<! ch)]
        (when (not (nil? v))
          (if (and dropping? (pred v))
            (recur true (<! ch))
            (do
              (>! out v)   
              (recur false (<! ch))))))
      (async/close! out))
    out))

(defn my-take-while [pred ch]
  (let [out (chan)]
    (go
      (loop [v (<! ch)]
        (when (and (not (nil? v))
                   (pred v))
          (>! out v)
          (recur (<! ch))))
      (async/close! out))
    out))

(defn stream-subsets-of-data []
  (let [stream (async/mult (to-chan [1 2 3 4 5]))]
    (listen (async/filter< even? (tap stream (chan)))
            #(println "where:" %))
    (listen (async/take 3 (tap stream (chan (async/dropping-buffer 1))))
            #(println "take:" %))
    (listen (my-drop 3 (tap stream (chan)))
            #(println "drop:" %))
    (listen (my-take-while #(< % 3) (tap stream (chan (async/dropping-buffer 1))))
            #(println "take-while:" %))
    (listen (my-drop-while #(< % 3) (tap stream (chan)))
            #(println "drop-while:" %))))

(defn transforming-stream []
  (let [stream (to-chan [1 2 3 4 5])
        transformed (async/mapcat< #(vector (str "Message: " %)
                                            (str "Body: " %))
                                   stream)]
    (listen transformed #(println "transform-listen:" %))))

(defn main []
  (node/enable-util-print!)
  (single-stream)
  (stream-properties)
  (broadcast)
  (stream-subsets-of-data)
  (transforming-stream))

(set! *main-cli-fn* main)
