(ns efreports.helpers.stream-manip-session-storage
  (:require [efreports.helpers.stream-session :as stream-sess]
            [efreports.helpers.stream-manipulations :as stream-manip]
            [efreports.models.streams-model :as stream-model]
            [clojure.set :as clj-set]
            [clojure.string :as clj-str]
            [clj-time.core :as clj-time]
            [clj-time.coerce :as clj-time-coerce]))


(defn extract-filter-params [stream-params]
  (select-keys stream-params
               (for [[k,v] stream-params :when (or (. (str k) startsWith ":filter-key")
                                                   (. (str k) startsWith ":filter-op-container")) ] k)))

(defn extract-keycol-params [stream-params]
  (map (fn [m] (keyword (clj-str/replace (str (key m)) #":key_col_ind_" "")))
                (select-keys stream-params
                             (for [[k,v] stream-params :when (. (str k) startsWith ":key_col_ind_")] k))))

(defn filter-map-replace-params->filter-map [stream-params]
  (let [filter-keys (select-keys stream-params (for [[k,v] stream-params :when (. (str k) startsWith ":filter-key")] k))
        filter-ops (select-keys stream-params (for [[k,v] stream-params :when (. (str k) startsWith ":filter-op")] k))
        keyvals (map #(assoc {} (keyword (clj-str/replace (str (key %)) #":filter-key-" "")) (val %)) filter-keys)
        keyops (map #(assoc {} (keyword (clj-str/replace (str (key %)) #":filter-op-" "")) (val %)) filter-ops)
        ]
      (for [kv keyvals]
        (assoc {} :keyval kv
                  :operator (->> keyops
                             (filter #(= (first (keys %)) (first (keys kv))))
                             first
                             vals
                             first)))))

(defmulti store-request-manip
  (fn [stream stream-params]
    (stream-params :fn)))

(defmethod store-request-manip nil
  [stream stream-params]

  (when (empty? (stream-sess/stream-attributes (stream-params :username) stream))
    (stream-sess/init-stream-session (stream-params :username) stream))
)


(defmethod store-request-manip "filter-cols"
  [stream stream-params]
  (stream-sess/copy-check-params-to-session stream stream-params (stream-params :username) :filter-cols))

(defmethod store-request-manip "total-stream"
  [stream stream-params]
  (stream-sess/copy-check-params-to-session stream
                                          stream-params (stream-params :username) :total-cols)
  (stream-sess/copy-check-params-to-session stream
                                          stream-params (stream-params :username) :filter-cols) ;;always allow for filtering by total columns
  )

(defmethod store-request-manip "filter-map-add"
  ;;This needs to be an additive operation. So merge filter maps already in the session with those being passed via the request
  [stream stream-params]
  (stream-sess/write-stream-keys (stream-params :username) stream
                :filter-map (conj ((stream-sess/stream-attributes (stream-params :username) stream) :filter-map)
                                  (into {} (for [f (extract-filter-params stream-params)]
                                             (if (= (key f) :filter-op-container)
                                               (assoc {} :operator (val f))
                                               (assoc {} :keyval (assoc {} (keyword (clj-str/replace-first (str (key f)) #":filter-key-" "")) (val f))))))
                              ))
  (stream-sess/write-stream-keys (stream-params :username) stream :total-cols nil)
  (stream-sess/move-column-to-back (stream-params :username) stream
                                   ((stream-sess/stream-attributes (stream-params :username) stream) :column-map-ordering)
                                   "total")
  (stream-sess/write-stream-keys (stream-params :username) stream :column-map-ordering
   (remove #(= (% :name) "total")
           ((stream-sess/stream-attributes (stream-params :username) stream) :column-map-ordering))))

(defmethod store-request-manip "filter-map-replace"
  [stream stream-params]
  (println "parms " stream-params)
  (stream-sess/write-stream-keys (stream-params :username) stream
                                  :filter-map (filter-map-replace-params->filter-map stream-params)))

(defmethod store-request-manip "map-stream"
  [stream stream-params]
  (let [sanitized-to-stream (clj-str/replace (stream-params :to-stream) #"%20" " ")]
    (when (empty? (filter #(= % sanitized-to-stream)
                     ((stream-sess/stream-attributes (stream-params :username) stream) :mapped-streams)))
      (stream-sess/write-stream-keys (stream-params :username) stream
                                 :mapped-streams
                                 (concat ((stream-sess/stream-attributes (stream-params :username) stream) :mapped-streams)
                                       [sanitized-to-stream])))))

(defmethod store-request-manip "unmap-stream"
  [stream stream-params]
  (prn (str "Removing " (remove #(= % (stream-params :to-stream))
                                           ((stream-sess/stream-attributes (stream-params :username) stream) :mapped-streams))))
  (stream-sess/write-stream-keys (stream-params :username)  stream :column-map-ordering
                   (stream-manip/init-column-map-ordering ((stream-model/find-stream-map stream) :column-map) 0))
  (stream-sess/write-stream-keys (stream-params :username) stream
                                 :mapped-streams ;;need to add code to actually remove the mapping
                                 (remove #(= % (clj-str/replace (stream-params :to-stream) #"%20" " "))
                                           ((stream-sess/stream-attributes (stream-params :username) stream) :mapped-streams))))

(defmethod store-request-manip "refresh"
  [stream stream-params]
  (prn (str "huh "  (clj-time-coerce/from-string (stream-params :refresh-datetime))))
  (stream-sess/write-stream-keys (stream-params :username) stream
                                 :last-refresh (clj-time-coerce/from-string (stream-params :refresh-datetime)))
  )

(defmethod store-request-manip "sort"
  [stream stream-params]
  (prn (str "sort params " stream-params))
  (stream-sess/write-stream-keys (stream-params :username) stream :sort-map
                                 (select-keys stream-params
                                              (for [[k,v] stream-params
                                                    :when (and (not (empty? v)) (not (= k :fn))
                                                               (not (= k :stream)) (not (= k :username)))]
                                                k)))
)


(defmethod store-request-manip "pivot-totals"
  [stream stream-params]
  (stream-sess/write-stream-keys (stream-params :username) stream :pivot-totals
                                                                 {:x-key (stream-params :x-key)
                                                                  :y-key (stream-params :y-key)})
  (stream-sess/write-stream-keys (stream-params :username) stream :filter-cols nil)
  (stream-sess/write-stream-keys (stream-params :username) stream :total-cols nil)
  (stream-sess/write-stream-keys (stream-params :username) stream :mapped-streams nil)
  )


(defmethod store-request-manip "unpivot-totals"
  [stream stream-params]
  (stream-sess/write-stream-keys (stream-params :username) stream :pivot-totals nil)
  (stream-sess/write-stream-keys (stream-params :username)  stream :column-map-ordering
                   (stream-manip/init-column-map-ordering ((stream-model/find-stream-map stream) :column-map) 0))
  )
