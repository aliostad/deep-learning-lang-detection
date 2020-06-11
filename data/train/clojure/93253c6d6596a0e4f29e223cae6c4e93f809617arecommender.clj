(ns matchbox.services.recommender
  (:require clojure.string
            [matchbox.config :refer [db-specification coll-ratings]]
            [matchbox.models.user :as user])
  (:import org.apache.mahout.cf.taste.impl.model.mongodb.MongoDBDataModel
           org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity
           org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood
           org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender))


(defn get-datamodel
  "INTERNAL: Retrieve access to data model"
  []
  (MongoDBDataModel. (db-specification :servername)
                     (db-specification :port)
                     (db-specification :database)
                     coll-ratings                           ; collection name
                     false false nil))                        ; manage finalRemove dateFormat
                     ;;"user_id" "item_id" "preference"       ; column names for recommendations
                     ;;"mongo_data_model_map"))               ; mapping collection name

;; TODO: make private
(defn id-to-long
  "From User Object-ID (String) to a Long Value"
  [model id]
  (Long/parseLong (.fromIdToLong model id true)))

;; TODO: make private
(defn long-to-id
  "From Long Value to an User Object-ID (String)"
  [model id]
  (.fromLongToId model id))


(defn find-similar-users
  "Returns n most similar users compared to given user-id."
  [n user-id]
  (let [model (get-datamodel)
        similarity (PearsonCorrelationSimilarity. model)
        neighborhood (NearestNUserNeighborhood. 2 similarity model)
        recommender (GenericUserBasedRecommender. model neighborhood similarity)
        long-id (id-to-long model user-id)
        similar-users (.mostSimilarUserIDs recommender long-id n)]

    ;; translate LongIds as returned by Mahout, into users by using MongoDB's ObjectID
    (println "-- similar users:" (count similar-users))
    (map (fn [user-id]
           (user/find-by-id (long-to-id model user-id)))
         similar-users)))


(comment
  (find-similar-users 3 0))