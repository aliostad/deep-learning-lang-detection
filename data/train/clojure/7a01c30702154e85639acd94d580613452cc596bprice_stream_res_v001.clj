(ns pe-fp-rest.resource.price-stream.version.price-stream-res-v001
  (:require [pe-fp-rest.meta :as meta]
            [clojure.tools.logging :as log]
            [clojure.walk :refer [walk]]
            [clj-time.core :as t]
            [clj-time.coerce :as c]
            [pe-core-utils.core :as ucore]
            [pe-user-rest.utils :as userresutils]
            [pe-fp-core.core :as fpcore]
            [pe-fp-core.validation :as fpval]
            [pe-fp-rest.resource.price-stream.price-stream-res :refer [body-data-in-transform-fn
                                                                       body-data-out-transform-fn
                                                                       load-price-stream-fn]]))

(defmethod body-data-in-transform-fn meta/v001
  [version
   price-stream-filter-criteria]
  (ucore/transform-map-val price-stream-filter-criteria
                           :price-stream-filter/price-events-after
                           #(c/from-long (Long. (:price-stream-filter/price-events-after %)))))

(defmethod body-data-out-transform-fn meta/v001
  [version
   db-spec
   base-url
   entity-uri-prefix
   entity-uri
   price-stream]
  (let [price-events (:price-event-stream price-stream)]
    {:price-event-stream (map
                          (fn [price-event]
                            (ucore/transform-map-val price-event
                                                     :price-event/event-date
                                                     #(c/to-long %)))
                          price-events)}))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 0.0.1 Load price-stream function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmethod load-price-stream-fn meta/v001
  [version
   db-spec
   base-url
   entity-uri-prefix
   price-stream-uri
   auth-token
   filter-criteria
   merge-embedded-fn
   merge-links-fn
   min-distance-diff-fs]
  (let [contains-latitude (contains? filter-criteria :price-stream-filter/latitude)
        contains-longitude (contains? filter-criteria :price-stream-filter/longitude)
        contains-distance-within (contains? filter-criteria :price-stream-filter/distance-within)
        contains-price-events-after (contains? filter-criteria :price-stream-filter/price-events-after)
        contains-sort-by-fields (contains? filter-criteria :price-stream-filter/sort-by)
        contains-max-results (contains? filter-criteria :price-stream-filter/max-results)
        latitude (:price-stream-filter/fs-latitude filter-criteria)
        longitude (:price-stream-filter/fs-longitude filter-criteria)
        distance-within (:price-stream-filter/fs-distance-within filter-criteria)
        price-events-after (:price-stream-filter/price-events-after filter-criteria)
        sort-by (:price-stream-filter/sort-by filter-criteria)
        max-results (:price-stream-filter/max-results filter-criteria)]
    (if (and (if contains-latitude (and (number? latitude)) true)
             (if contains-longitude (and (number? longitude)) true)
             (if contains-distance-within (and (number? distance-within) (>= distance-within 0)) true)
             (if contains-price-events-after (and (not (nil? price-events-after))) true)
             (if contains-sort-by-fields (and (not (empty? sort-by))) true)
             (if contains-max-results (and (number? max-results) (> max-results 0)) true))
      (let [price-events (if (= sort-by "distance")
                           (fpcore/nearby-price-events db-spec
                                                       latitude
                                                       longitude
                                                       distance-within
                                                       price-events-after
                                                       max-results
                                                       min-distance-diff-fs)
                           (fpcore/nearby-price-events-by-price db-spec
                                                                latitude
                                                                longitude
                                                                distance-within
                                                                price-events-after
                                                                max-results
                                                                min-distance-diff-fs))]
        {:status 200
         :do-entity {:price-event-stream price-events}})
      {:status 400})))
