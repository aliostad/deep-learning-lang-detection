(ns savant.store.redis
  (:require [slingshot.slingshot :refer (throw+)]
            [savant.util :refer (hex-digest with-meta-merge named?)]
            [savant.core :refer
            (IEventStore IEventStream exists? get-stream get-rev-id
             create-stream get-tip get-events-vec get-commits-seq)]
            [taoensso.carmine :as redis]))

;;;;;;;;;;;;;;;;;;;;

(def redis-defaults
  {:host     "127.0.0.1"
   :port     6379
   :password ""
   :timeout  4000})

(defn redis-stream-key [bucket-name stream-id]
  (format "%s/%s" bucket-name stream-id))

(defmacro carmine
  "Acts like (partial with-conn pool spec-server1)."
  [store & body] `(redis/with-conn (:pool ~store) (:server-spec ~store) ~@body))

;;;;;;;;;;;;;;;;;;;;

(declare -get-stream-tip)
(declare -get-stream-vector)
(declare -bind-stream-to-rev)
(declare -build-first-commit-hash)
(declare -create-stream)
(declare -validate-options!)

;;;;;;;;;;;;;;;;;;;;

(defn- -get-stream-tip [stream-state]
  (:event-store/rev-hash (meta (last stream-state))))

(defn -build-first-commit-hash [stream])

(defn -get-stream-vector [bucket-name stream-id store]
  (carmine store
           (redis/lrange (redis-stream-key bucket-name stream-id) "1" "10000")))
;; TODO: ^ have a better call for lrange

;;;;;;;;;;;;;;;;;;;;

(defrecord RedisEventStream [bucket-name stream-id store state-atom current-rev]
  IEventStream

  (get-rev-id [this] current-rev)

  (get-tip [this] (-get-stream-tip (-get-stream-vector bucket-name stream-id store)))

  (tip? [this] (= current-rev (get-tip this)))

  (get-commits-seq [this]
    (let [commits (seq (-get-stream-vector bucket-name stream-id store))]
      (if (nil? current-rev)
        commits
        (take-while #(not= current-rev
                           (-> % meta :event-store/parent-rev-hash))
                    commits))))

  (get-events-seq [this] (seq (get-events-vec this))) ;...

  (get-events-vec [this] (into [] (flatten (get-commits-seq this))))
  ;; TODO: use redis LRANGE function

  (get-events-vec [this from-event-id]
    (subvec (get-events-vec this) from-event-id))

  (get-events-vec [this from-event-id to-event-id]
    (subvec (get-events-vec this) from-event-id to-event-id))

  (commit-events! [this events]
    (let [parent-hash (or current-rev (-build-first-commit-hash this))
          new-rev-hash (hex-digest [parent-hash events])]
      (letfn [
              (update-stream-state [_]
                (let [tip (get-tip this)]
                  (when (not (= current-rev tip))
                    (throw+ [:type :event-store/conflict-detected
                             :msg (format "conflicting versions current: %s and tip: %s" current-rev tip)]))
                  (carmine store
                    (redis/rpush (redis-stream-key bucket-name stream-id)
                                 (with-meta-merge events {:event-store/parent-rev-hash parent-hash
                                                          :event-store/rev-hash new-rev-hash})))
                  nil))]
        (swap! state-atom update-stream-state)
        (-bind-stream-to-rev this new-rev-hash)))))

(defrecord RedisEventStore [pool server-spec stream-atoms]
   IEventStore
   (-same-store? [this other-store]
     (= server-spec (:server-spec other-store)))

   (exists? [this bucket-name stream-id]
     (= 1
        (carmine this
                 (redis/exists (redis-stream-key bucket-name stream-id)))))

   (create-stream [this bucket-name stream-id]
     (-create-stream this bucket-name stream-id))

   (get-stream [this bucket-name stream-id]
     (get-stream this bucket-name stream-id {}))

   (get-stream [this bucket-name stream-id {:keys [rev] :as opts}]
     (if (exists? this bucket-name stream-id)
       (map->RedisEventStream {:bucket-name  bucket-name
                               :stream-id stream-id
                               :store this
                               :state-atom (get @stream-atoms [bucket-name stream-id])
                               :current-rev rev})
       nil)))

;;;;;;;;;;;;;;;;;;;;

(defn- -bind-stream-to-rev [stream rev]
  (let [rev (or rev (get-tip stream))]
    (if (= (get-rev-id stream) rev)
      stream
      (assoc stream :current-rev rev))))

(defn- -create-stream
  [store bucket-name stream-id]
  {:pre [(named? bucket-name)
         (named? stream-id)]}
  (if (exists? store bucket-name stream-id)
    (throw+ {:type :event-store/stream-exists
             :message "stream was already created"}))
  (swap! (.stream-atoms store) assoc [bucket-name stream-id] (atom nil))
  (carmine store
           (redis/rpush (redis-stream-key bucket-name stream-id) nil))
  (get-stream store bucket-name stream-id))


(defn- -validate-options! [opts])
;;   (cond
;;     (nil? name)
;;     (throw+ {:type :event-store/invalid-options
;;              :message ":name option is required"})

;;     (nil? init-map)
;;     (throw+ {:type :event-store/invalid-options
;;              :message ":init-map must be a map"})))

;;;;;;;;;;;;;;;;;;;;

 (defn get-event-store
   ([opts]
   ;; ^ NOTE: we are not doing destructuring here to have a simple signature
   ;;   that can be verified in tests
      (let [{:keys [redis-config pool]} opts]
            (-validate-options! opts)
            (map->RedisEventStore
                {:pool (or pool
                           (redis/make-conn-pool :max-active 8))
                 :server-spec (apply redis/make-conn-spec
                                     (merge redis-defaults
                                            redis-config))
                 :stream-atoms (atom {})}))))
