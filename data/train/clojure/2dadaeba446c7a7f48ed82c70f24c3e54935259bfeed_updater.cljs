(ns ghoul.worker.feed-updater
  (:require-macros [cljs.core.async.macros :refer [go go-loop]])
  (:require [cljs.core.async :as async :refer [<! timeout]]
            [ghoul.common.http :as http]
            [ghoul.repository.item :as storage]
            [tubax.core :refer [xml->clj]]
            ))
(enable-console-print!)

(println ">> WORKER STARTED <<")

(defn update-feed [feed-uid feed-url]
  (go
    (println "Refreshing.. " feed-url)
    (let [feed-data (-> feed-url http/get-rss <! :data :items)]
      (doseq [feed feed-data]
        (let [result (<! (storage/get-item feed-uid (:uid feed)))]
          (if (= result :not-found)
            (do
              (let [to-store (-> feed (assoc :feeduid feed-uid))]
                (-> to-store storage/add-item <!)
                (js/postMessage (clj->js {:action "update" :result "ok" :data to-store}))))))))))

(defn manage-command [event]
  (let [data (-> event
                 .-data
                 (js->clj :keywordize-keys true))]
    (cond (= (:action data) "update") (update-feed (:uid data) (:url data))
          :else (println event))))

(js/addEventListener "message" manage-command)
(storage/init-database)
