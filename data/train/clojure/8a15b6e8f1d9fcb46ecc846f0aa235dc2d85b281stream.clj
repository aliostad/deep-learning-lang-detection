(ns de.sveri.was.routes.stream
  (:require [compojure.core :refer :all]
            [selmer.filters :as filt]
            [de.sveri.was.layout :as layout]
            [de.sveri.was.service.reddit :as red]))

;(filt/add-filter! :removestring (fn [s] [:safe (subs s 1 (- (count s) 1))]))

(defn stream-page [url]
  (println (red/get-live-streams @red/comments-state))
  (let [stream (first (filter #(= url (:author %)) (red/get-live-stream-data)))]    
    (layout/render "stream/index.html" {:stream stream})))


(defroutes stream-routes
           (GET "/stream/" [url] (stream-page url)))
