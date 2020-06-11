(ns re-alm.io.datastore
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [clojure.set :as set]
            [cljs.core.async :as async]
            [re-alm.core :as ra]))

(def datastore-atom (atom {}))

(defn- get-datastore-value [key]
  (get @datastore-atom key))

(defrecord DatastoreWatch [key]
  ra/ITopic
  (make-event-source [this dispatch subscribers]
    (let [ch-ctrl (async/chan)
          ch-atom (async/chan)
          watch-fn (fn [_ _ old-state new-state]
                     (let [old-value (get old-state key)
                           new-value (get new-state key)]
                       (when (not= new-value old-value)
                         (async/put! ch-atom new-value))))]
      (add-watch datastore-atom key watch-fn)
      (go
        ; dispatch current value to initial subscribers
        (ra/dispatch-to-subscribers dispatch subscribers (get-datastore-value key))
        (loop [subscribers subscribers]
          (let [[v ch] (async/alts! [ch-ctrl ch-atom])]
            (if (= ch ch-ctrl)
              (if (= v :kill)
                (remove-watch datastore-atom :new)
                (let [subscribers' (second v)
                      new-subscribers (set/difference (set subscribers') (set subscribers))]
                  ; dispatch current value to newly joined subscribers
                  (ra/dispatch-to-subscribers dispatch new-subscribers (get-datastore-value key))
                  (recur subscribers')))
              (do
                (ra/dispatch-to-subscribers dispatch subscribers v)
                (recur subscribers))))))
      ch-ctrl)))

(defn datastore [key msg]
  (ra/subscription (->DatastoreWatch key) msg))

(defrecord ReadStoreFx [key taggers]
  ra/IEffect
  (execute [this dispatch]
    (let [value (get-datastore-value key)]
      (dispatch (ra/build-msg taggers value))))
  ra/ITaggable
  (tag-it [this tagger]
    (update this :taggers conj tagger)))

(defn read-store-fx [key done]
  (->ReadStoreFx key [done]))

(defrecord WriteStoreFx [key value]
  ra/IEffect
  (execute [this dispatch]
    (swap! datastore-atom (fn [datastore]
                            (assoc datastore key value)))))

(defn write-store-fx [key value]
  (->WriteStoreFx key value))

