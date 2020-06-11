(ns kilgore.store
  (:require [taoensso.carmine :as car :refer [wcar]])
  (:import (java.util Date)))

(defprotocol IStore
  (->stream-key [_ stream-id])
  (->stream-id [_ stream-key])
  (events [_ stream-id] [_ stream-id opts])
  (record-event! [_ stream-id event])
  (version [_ stream-id])
  (stream-ids [_])
  (delete! [_ stream-id])
  (rename! [_ stream-id new-stream-id]))

(defrecord AtomStore [opts]
  IStore

  (->stream-key [_ stream-id]
    stream-id)

  (->stream-id [_ stream-id]
    stream-id)

  (events [_ stream-id] (events _ stream-id {}))

  (events [this stream-id {:keys [offset] :or {offset 0}}]
    (drop offset (get @(:store-atom opts) (->stream-key this stream-id))))

  (record-event! [this stream-id event]
    (let [event (if (:tstamp event) event (assoc event :tstamp (Date.)))]
      (swap! (:store-atom opts)
             update-in [(->stream-key this stream-id)] #((fnil conj []) % event))))

  (version [this stream-id]
    (count (get @(:store-atom opts) (->stream-key this stream-id))))

  (stream-ids [this]
    (->> @(:store-atom opts)
         keys
         (map (partial ->stream-id this))
         set))

  (delete! [this stream-id]
    (swap! (:store-atom opts)
           dissoc (->stream-key this stream-id)))

  (rename! [this stream-id new-stream-id]
    (swap! (:store-atom opts)
           (fn [v]
             (-> v
                 (assoc (->stream-key this new-stream-id)
                        (get v (->stream-key this stream-id)))
                 (dissoc (->stream-key this stream-id)))))))

(defrecord CarmineStore [opts]
  IStore

  (->stream-key [_ stream-id]
    (let [{:keys [key-prefix]} opts]
      (str (when key-prefix (str key-prefix ":"))
           "events:" stream-id)))

  (->stream-id [this stream-key]
    (subs stream-key (count (->stream-key this ""))))

  (events [_ stream-id]
    (events _ stream-id {}))

  (events [this stream-id {:keys [chunk-size offset]
                           :or {chunk-size 100, offset 0}}]
    (let [chunk (wcar (:connection opts)
                      (car/lrange (->stream-key this stream-id)
                                  offset
                                  (dec (+ offset chunk-size))))]
      (if (= chunk-size (count chunk))
        (lazy-cat chunk
                  (events this stream-id {:chunk-size chunk-size
                                          :offset (+ offset chunk-size)}))
        chunk)))

  (record-event! [this stream-id event]
    (let [event (if (:tstamp event) event (assoc event :tstamp (Date.)))]
      (wcar (:connection opts)
            (car/rpush (->stream-key this stream-id) event))))

  (version [this stream-id]
    (wcar (:connection opts)
          (car/llen (->stream-key this stream-id))))

  (stream-ids [this]
    (->> (wcar (:connection opts)
               (car/keys (->stream-key this "*")))
         (map (partial ->stream-id this))
         set))

  (delete! [this stream-id]
    (wcar (:connection opts)
          (car/del (->stream-key this stream-id))))

  (rename! [this stream-id new-stream-id]
    (wcar (:connection opts)
          (car/rename (->stream-key this stream-id)
                       (->stream-key this new-stream-id)))))

(defn acquire [{:keys [type] :or {type :atom}
                :as opts}]
  {:pre [(or (not= type :atom) (contains? opts :store-atom))]}
  (case type
    :atom (->AtomStore opts)
    :carmine (->CarmineStore opts)))
