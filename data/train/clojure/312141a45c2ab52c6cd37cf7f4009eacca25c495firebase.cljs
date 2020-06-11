(ns app.firebase
  (:require [goog.string :refer [format]]
            [re-frame.core :refer [dispatch]]
            [cljsjs.firebase]))

(defonce firebase-url "https://hacker-news.firebaseio.com/v0")

(defonce firebase-config
  (clj->js {;; apiKey: "<API_KEY>",
            ;; authDomain: ".firebaseapp.com",
            "databaseURL" "https://hacker-news.firebaseio.com",
            ;; storageBucket: "<BUCKET>.appspot.com",
            ;; messagingSenderId: "<SENDER_ID>",
            }))

;; TODO: use sth. like mount or component to manage state
(defonce firebase-app (.initializeApp js/firebase firebase-config "APP-NAME"))
(def firebase-ref (-> firebase-app .database (.ref "/v0")))

(defn query-handler-dispatch
  "Dispatch value depending on the type of handler.

  fn? .. invoke with value
  keyword? .. re-frame dispatch an event with [keyword value]
  nil? .. debug print it (console.log & prn)

  any other handler type raises an assertion error"
  [handler value]
  (cond (fn? handler) (handler value)
        (keyword? handler) (re-frame.core/dispatch [handler value])
        (nil? handler) (do (js/console.log value) (prn value))
        :else (assert false (format "invalid handler type %s" (type handler)))))

(defn get-topstory-ids
  "Query for topstories and dispatch on handler with the resulting list of ids."
  [handler]
  (-> firebase-ref
      (.child "topstories")
      (.once "value" #(query-handler-dispatch handler (js->clj (.val %))))))

(defn get-items-by-id
  "Query for topstories and dispatch on handler with the resulting list of items."
  [item-ids handler]
  ;; there *must* be a better way to fetch a random collection from firebase!
  (when (not-empty item-ids)
    (let [fetched-count (atom 0)
          result (atom [])
          item-ref (-> firebase-ref (.child "item"))]
      (doseq [id item-ids]
        (-> item-ref
            (.child id)
            (.once "value"
                   (fn [firebase-snapshot]
                     ;; consider using transit-cljs as js->clj is supposedly *slow*
                     (swap! result conj (js->clj (.val firebase-snapshot)))
                     (swap! fetched-count inc)
                     (when (= @fetched-count (count item-ids))
                       (query-handler-dispatch handler @result)))))))))

(defn get-topstories
  "Return limit number of topstories."
  [limit handler]
  (get-topstory-ids (fn [ids] (query-handler-dispatch handler (take (or limit 10) ids)))))
