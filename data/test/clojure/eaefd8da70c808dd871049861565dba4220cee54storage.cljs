(ns re-alm.io.storage
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [clojure.set :as set]
            [cljs.core.async :as async :refer [put!]]
            [alandipert.storage-atom :refer [local-storage]]
            [re-alm.core :as ra]))

(def localstorage-atoms (atom {}))

(defn- get-or-create-localstorage-atom [path]
  (get
    (swap! localstorage-atoms (fn [a]
                                (if (get a path)
                                  a
                                  (assoc a path (local-storage (atom nil) path)))))
    path))

(defn- remove-localstorage-atom [path]
  (swap! localstorage-atoms (fn [a] (dissoc a path))))

(defrecord LocalStorageWatch [path]
  ra/ITopic
  (make-event-source [this dispatch subscribers]
    (let [ch-ctrl (async/chan)
          ch-atom (async/chan)
          storage-atom (get-or-create-localstorage-atom path)
          watch-fn (fn [_ _ _ v]
                     (put! ch-atom v))]
      (add-watch storage-atom :new watch-fn)
      (go
        ; dispatch current value to initial subscribers
        (ra/dispatch-to-subscribers dispatch subscribers @storage-atom)
        (loop [subscribers subscribers]
          (let [[v ch] (async/alts! [ch-ctrl ch-atom])]
            (if (= ch ch-ctrl)
              (if (= v :kill)
                (remove-watch storage-atom :new)
                (let [subscribers' (second v)
                      new-subscribers (set/difference (set subscribers') (set subscribers))]
                  ; dispatch current value to newly joined subscribers
                  (ra/dispatch-to-subscribers dispatch new-subscribers @storage-atom)
                  (recur subscribers')))
              (do
                (ra/dispatch-to-subscribers dispatch subscribers v)
                (recur subscribers)))))) `ch-ctrl)))

(defn storage [path msg]
  (ra/subscription (->LocalStorageWatch path) msg))

(defrecord ReadStorageFx [path taggers]
  ra/IEffect
  (execute [this dispatch]
    (let [atom (get-or-create-localstorage-atom path)]
      (dispatch (ra/build-msg taggers @atom))))
  ra/ITaggable
  (tag-it [this tagger]
    (update this :taggers conj tagger)))

(defn read-storage-fx [path done]
  (->ReadStorageFx path [done]))

(defrecord WriteStorageFx [path value]
  ra/IEffect
  (execute [this dispatch]
    (let [storage-atom (get-or-create-localstorage-atom path)]
      (reset! storage-atom value))))

(defn write-storage-fx [path value]
  (->WriteStorageFx path value))
