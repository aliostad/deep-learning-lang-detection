(ns experiment.models.samples
  (:use experiment.infra.models
        clojure.math.numeric-tower)
  (:require [clojure.tools.logging :as log]
            [somnium.congomongo :as mongo]
            [experiment.models.schedule :as schedule]
            [clj-time.core :as time]
            [experiment.libs.datetime :as dt]))


;; User:
;; -------------------
;;
;; - ID

;; Instrument:
;; -------------------
;;
;; - ID
;; - sampling
;;   - interval (chunk interval)
;;   - poll-freq (how often to check for new data - daily, hourly, weekly)

(defn chunk-interval [inst]
  (get-in inst [:sampling :chunksize] :month))

;; Sample:
;; -------------------
;; - :ts
;; - :v <default or time-series value>
;; - <can have arbitrary extra data, but has cost impact on queries>

(defn valid-sample? [sample]
  (and (:ts sample)
       (= (type (:ts sample)) org.joda.time.DateTime)
       (:v sample)
       true))

(defn valid-samples? [samples]
  (and (or (seq? samples) (vector? samples))
       (every? valid-sample? samples)))

(defn- as-chunk-sample
  "Convert Joda Time objects to Java Date objects"
  [sample]
  (update-in sample [:ts] dt/as-date))

(defn- as-native-sample
  [sample]
  (update-in sample [:ts] dt/from-date))
          
(defn- merge-sample [old new]
  (assert (= (:start old) (:start new)))
  (merge old new))

(defn- merge-samples
  "Identity is determined by :ts date object;
   new values trump old values according to merge policy
   all non-conflicting values are included"
  [old new]
  (vals
   (merge-with
    merge-sample
    (zipmap (map :ts old) old)
    (zipmap (map :ts new) new))))

;; Chunk:
;; -------------------
;;
;; - ID
;; - user
;; - inst
;; - start <date>
;; - samples []
;;   - ts
;;   - v
;;   - <domain-specific>
;; - stats
;;   - sum (v)
;;   - count (v)

(defn- get-chunk [u i base & [restrict?]]
  (mongo/fetch-one
   :chunks
   :where {:user (:_id u)
           :inst (:_id i)
           :start (dt/as-date base)}))

(defn- update-chunk [u i base old-chunk samples]
  (let [select {:user (:_id u)
                :inst (:_id i)
                :start (dt/as-date base)}
        update {:$set {:updated (dt/as-date (dt/now))
                       :samples samples
                       :stats.count (count samples)
                       :stats.sum (when (number? (:v (first samples)))
                                    (apply + (map :v samples)))
                       }
                :$inc {"updates" 1}}]
    (mongo/update!
     :chunks
     (if old-chunk
       (assoc select
         :stats.count (get-in old-chunk [:stats :count])
         :stats.sum (get-in old-chunk [:stats :sum]))
       select)
     update
     :upsert (not old-chunk))))

(defn- chunk-update-fn
  "Given a user and interval, return a function
   that will update the state of a chunk for a given
   base date and set of samples"
  [u i]
  (assert (and (= (:type u) "user") (= (:type i) "instrument")
               (:_id u) (:_id i)))
  (fn [[base-date samples]]
    (let [old-chunk    (get-chunk u i base-date)
          old-samples  (:samples old-chunk)
          new-samples  (merge-samples old-samples
                                      (map as-chunk-sample samples))
          result       (update-chunk u i base-date
                                     old-chunk new-samples)]
      true)))
           
(defn- date-decimator-fn
  "Return a canonical date given the chunksize period"
  [chunksize key-fn]
  (comp (schedule/decimate-fn chunksize) key-fn))

(defn sample-groups
  "Return samples as groups defined by date decimator"
  [inst samples]
  (assert (valid-samples? samples))
  (group-by (date-decimator-fn (chunk-interval inst) :ts)
            samples))
  
(defn- chunk-select
  "Return a where clause for mongo lookups to get the target chunks"
  ([u i]
     {:inst (:_id i) :user (:_id u)})
  ([u i options]
     (let [{:keys [start end]} options]
       (merge (chunk-select u i)
              (when start
                {:start {:$gte (dt/as-date start)}})
              (when end
                {:start {:$lte (dt/as-date end)}})))))

(defn- sample-filter-fn
  "Return a filter function to select only those samples
   meeting the criterion outlined in the option set"
  ([options]
     (let [{:keys [start end]} options]
       (fn [sample]
         (and sample
              (or (not start)
                  (time/after? (:ts sample) start))
              (or (not end)
                  (time/before? (:ts sample) end)))))))

(defn- batch-remove-overlapping-samples
  "If more than one point exists for decimation level, remove the
   earlier one."
  [instrument samples]
  (let [dfn (date-decimator-fn (keyword (or (:pointscale instrument) "day")) :ts)]
    (map (fn [samples]
           (if (> (count samples) 1)
             (first (reverse (sort-by :ts samples)))
             (first samples)))
         (map second
              (group-by (fn [sample]
                          (dfn sample))
                        samples)))))

(defn- remove-overlapping-samples
  "If more than one point exists for decimation level, remove the
   earlier one.  Input must be sorted."
  [instrument samples]
  (let [dfn (date-decimator-fn (keyword (or (:pointscale instrument) "day")) :ts)]
    (loop [last nil
           results '()
           samples samples]
      (if (empty? samples)
        (reverse (cons last results))
        (if (and last (= (compare (dfn last) (dfn (first samples))) 0))
          (recur (first samples) results (next samples))
          (recur (first samples) (if last (cons last results) results) (next samples)))))))

(defn- update-all-samples [fn & [inhibit]]
  (doseq [chunk (doall (mongo/fetch :chunks))]
    (let [samples (doall (map fn (:samples chunk)))]
      (when (and (not inhibit)
                 (= (count samples) (count (:samples chunk)))
                 (not (= samples (:samples chunk))))
        (update-model!
         (assoc chunk :samples samples))))))
      

;; API

(defn add-samples
  "Insert new samples into array"
  [u i data]
  (doall
   (map (chunk-update-fn u i)
        (sample-groups i data))))
  
(defn rem-samples
  "Remove samples"
  [u i & {:keys [start end] :as options}]
  (mongo/destroy! :chunks (chunk-select u i options)))

(defn get-chunks
  ([where-clause only]
     (mongo/fetch :chunks
                  :where where-clause
                  :only only))
  ([where-clause]
     (mongo/fetch :chunks
                  :where where-clause)))

(defn get-samples
  "Get a sequence of samples {:ts <date> :v <any> ...}"
  [u i & {:keys [start end] :as options}]
  (->> (get-chunks (chunk-select u i options) [:samples])
       (mapcat :samples)
       (map as-native-sample)
       (sort-by :ts)
       (remove-overlapping-samples i)
       (filter (sample-filter-fn options))))

;; ## Last Updated

(defn last-sample [u i]
  (->> (mongo/fetch :chunks
                    :where (chunk-select u i)
                    :only [:samples]
                    :limit 1
                    :sort {:start -1})
       first
       :samples
       (sort-by :ts)
       first
       as-native-sample))

(defn last-sample-time [u i]
  (:ts (last-sample u i)))

(defn last-updated-time [u i]
  (when-let [updated
             (->> (mongo/fetch :chunks
                               :where (chunk-select u i)
                               :only [:updated]
                               :limit 1
                               :sort {:start -1})
                  first
                  :updated)]
    (dt/from-date updated)))

;; ## Recode sample values

(defn recode-sample-values
  "Update each sample in the seq of chunks with the response of mapfn"
  [mapfn chunks]
  (map (fn [chunk]
         (mongo/update! :chunks chunk
          (assoc chunk :samples
                 (vec (map mapfn (:samples chunk))))))
       chunks))

(defn map-recoder
  "Recode a sample according to map; if match on key, replace with value,
   otherwise keep unchanged"
  [map]
  (fn [sample]
    (if-let [new (map (:v sample))]
      (assoc sample :v new)
      sample)))

(comment
  (recode-sample-values
   (map-recoder {"y" "Yes" "m" "Mostly" "n" "No"})
   (get-chunks
    (chunk-select 
     (fetch-model :user {:username "eslick"})
     (fetch-model :instrument {:variable "Adherence"})
     {:start (dt/ago time/days 2)
      :end (dt/now)}))))
