(ns depends
  (:require
    [clojure.test.check.generators :as gen]
    [clojure.inspector :refer [atom?]]
    [clojure.spec :as spec]
    [clojure.spec.test :refer [instrument]]
    [manifold
     [time :as t]
     [stream :as s]
     [deferred :as d]]))

(spec/def ::anything
  (spec/with-gen (constantly true)
    (fn [] gen/any-printable)))

(spec/def ::complete d/deferred?)

(spec/def ::data-wrapper
  (spec/keys :req [::complete ::data]))

(spec/def ::read-lock d/deferred?)
(spec/def ::write-lock d/deferred?)

(spec/def ::dependency-item
  (spec/keys :req [::read-lock ::write-lock]))

(spec/def ::dependency-map
  (spec/map-of
    ::anything ::dependency-item))

(spec/def ::request-dependencies
  (spec/map-of
    ::anything #{:read :write}))

(defn- wrap-data
  [data completion-lock]
  {::data data
   ::complete completion-lock})

(defn- make-put-lock
  [dm dependencies]
  (apply
    d/zip
    (map
      (fn [[dep-name read-write]]
        (when-let [dep-locks (get dm dep-name)]
          (if (= read-write :write)
            (::write-lock dep-locks)
            (::read-lock dep-locks))))
      dependencies)))

(defn- chain-lock
  [target lock read-write]
  {::read-lock
   (if (= read-write :write)
     (d/chain
       (d/zip (::read-lock target) lock)
       (constantly true))
     (::read-lock target (d/success-deferred true)))
   ::write-lock
   (d/chain
     (d/zip (::write-lock target) lock)
     (constantly true))})

(defn- chain-completion-lock
  [completion-lock dm [dep-name read-write]]
  (update-in dm [dep-name] chain-lock completion-lock read-write))

(defn- merge-completion-lock
  [dm dependencies completion-lock]
  (reduce
    (partial chain-completion-lock completion-lock)
    dm dependencies))

(defn- chained-put!
  [dm incoming outgoing item waiting max-waiting]
  (let [dependencies (:dependencies (meta item))
        put-lock (make-put-lock dm dependencies)
        completion-lock (d/deferred)]
    @(d/loop []
       (if (and (not (nil? max-waiting)) (< max-waiting @waiting))
         (manifold.time/in 10 #(d/recur)) true))
    (swap! waiting inc)
    (d/chain
      put-lock
      (fn [_] (s/put! outgoing (wrap-data item completion-lock)))
      (fn [_] (swap! waiting dec))
      ;;; If this is the last item out, close the output stream.
      (fn [w] 
        (when
          (and (<= w 0) (s/drained? incoming))
          (s/close! outgoing))
        true))
    (merge-completion-lock dm dependencies completion-lock)))

(spec/fdef
  chained-put!
  :args (spec/cat
          ::dependency-map ::dependency-map
          ::incoming-stream s/source?
          ::outgoing-stream s/sink?
          ::chained-item ::anything
          ::waiting-atom atom?
          ::max-waiting (spec/nilable integer?))
  :ret ::dependency-map)

(instrument `chained-put!)

(defn- dissoc-realized
  "Remove all the items where both read and write locks have been realized."
  [dm]
  (apply
    (partial dissoc dm)
    (keep
      (fn [[k {read-lock ::read-lock write-lock ::write-lock}]]
        (when
          (and (d/realized? read-lock) (d/realized? write-lock)) k)) dm)))

(spec/fdef
  dissoc-realized
  :args (spec/cat ::dependency-map ::dependency-map)
  :ret ::dependency-map)

(instrument `dissoc-realized)

(defn- start-cron-clean-up!
  [dm interval]
  (t/every interval #(d/future (swap! dm dissoc-realized) true)))

(defn- start-chained-put-loop!
  [dm incoming outgoing waiting max-waiting]
  (d/loop []
    (d/chain
      (s/take! incoming ::drained)
      (fn [item]
        (if (identical? item ::drained)
          ::source-closed
          (do
            (swap! dm chained-put! incoming outgoing
                   item waiting max-waiting)
            (d/recur)))))))

(defn dependify
  "This creates an instance of a dependency manager.
  incoming is a anything that's sourceable by manifold.
  outgoing is anything that's sinkable by manifold.
  opts is a map of options to apply to this instance.
  Opts include :clean-up-interval in milliseconds and :max-waiting as an int."
  ([incoming outgoing] (dependify incoming outgoing {}))
  ([incoming outgoing opts]
   (let
     [incoming (s/->source incoming)
      outgoing (s/->sink outgoing)
      dm (atom {})
      waiting (atom 0)]
     {:dependency-state dm
      :waiting-state waiting
      :streams
      {:incoming incoming
       :outgoing outgoing}
      :tasks
      {:clean-up-cron
       (start-cron-clean-up!
         dm (:clean-up-interval opts (t/seconds 15)))
       :chained-put-loop
       (start-chained-put-loop!
         dm incoming outgoing waiting
         (:max-waiting opts))}})))

(spec/def ::dependency-state atom?)
(spec/def ::waiting-state atom?)
(spec/def ::clean-up-cron fn?)
(spec/def ::chained-put-loop d/deferred?)
(spec/def ::incoming s/source?)
(spec/def ::outgoing s/sink?)
(spec/def ::streams (spec/keys :req-un [::incoming ::outgoing]))
(spec/def ::tasks (spec/keys :req-un [::clean-up-cron ::chained-put-loop]))
(spec/def ::system (spec/keys :req-un [::dependency-state ::waiting-state ::tasks ::streams]))

(spec/def ::options
  (spec/keys :opt-un [::max-waiting ::clean-up-interval]))

(spec/fdef
  dependify
  :args (spec/or
          ::no-opts (spec/cat ::incoming s/sourceable?
                              ::outgoing s/sinkable?)
          ::with-opts (spec/cat ::incoming s/sourceable?
                                ::outgoing s/sinkable?
                                ::options ::options))
  :ret ::system)

(instrument `dependify)

(defn release!
  "This function takes in a depends data wrapper and attempts to release any
  lock it may have had on dependent data. True is always returned because if
  a d/success! returns false, it means the deferred has already been realized
  which is okay."
  [i]
  (d/success! (::complete i) true)
  true)

(spec/fdef
  release!
  :args (spec/cat ::data-wrapper ::data-wrapper)
  :ret true?)

(instrument `release!)

(defn consume
  "This function lets you consume data that could have data dependencies that
  must be respected. This function pulls the extra information out and gives
  the function the original information before it was passed into the dep
  manager. Once the function is done consuming the message, the deferred
  completion value is then realized so the lock on the data can be released."
  [dependency-item-stream f & args]
  (let [dependency-item-stream (s/->source dependency-item-stream)]
    (d/loop []
      (d/chain
        (s/take! dependency-item-stream ::drained)
        (fn [{data ::data complete ::complete :as msg}]
          (when (not (identical? ::drained msg))
            (d/chain
              (d/future (apply (partial f data) args) msg)
              #(release! %1)
              (fn [] (d/recur)))))))))

(spec/fdef
  consume
  :args (spec/cat ::incoming s/sourceable?
                  ::consumption-fn fn?
                  ::consumption-fn-args (spec/* ::anything))
  :ret d/deferred?)

(instrument `consume)

(defn apply-timeout!
  [item interval]
  (d/timeout! (::complete item) interval ::timeout)
  item)

(spec/fdef
  apply-timeout!
  :args (spec/cat ::item ::data-wrapper
                  ::interval integer?)
  :ret ::data-wrapper
  :fn #(identical? (:ret %) (-> % :args ::item)))

(instrument `apply-timeout!)

(defn map-timeout
  "Applies a timeout to the completion lock. This function returns a stream
  with the same items with the timeout applied."
  [dep-event-stream interval]
  (s/map
    #(apply-timeout! % interval)
    dep-event-stream))

(spec/fdef
  map-timeout
  :args (spec/cat ::source s/sourceable?
                  ::interval integer?)
  :ret s/stream?)

(instrument `map-timeout)

(defn map-release
  "Releases the dependencies on each item and emits the data on to the stream
  that gets returned from this function."
  [dep-event-stream]
  (let [out (s/stream)]
    (s/connect-via
      dep-event-stream
      (fn [i]
        (d/chain
          (s/put! out (::data i))
          (fn [_] (release! i)))) out) out))

(spec/fdef
  map-release
  :args (spec/cat ::source s/sourceable?)
  :ret s/stream?)

(instrument `map-release)

