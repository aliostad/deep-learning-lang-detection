(ns badge-displayer.db.manage-datomic  
  (:use [datomic.api :only [q db] :as d]))

(def uri "datomic:mem://badge-displayer")

(def schema-tx (read-string (slurp "resources/db/badge-displayer-schema.edn")))

(defn init-db
  ([] (init-db uri schema-tx))
  ([uri schema-tx]
     (when (d/create-database uri)
       @(d/transact (d/connect uri) schema-tx))
     (d/connect uri)))

(defn destroy-db []
  (d/delete-database uri))

(defn recreate-db []
  (destroy-db)
  (init-db))

(defn insert-entity
  [entity]
  "Inserts an (simple or complex) entity into Datomic."
  (d/transact (d/connect uri) entity))

(defn insert-entities  
  ([entities] 
  "Inserts a collection of (simple or complex) entities into Datomic."
   (for [entity entities]
     (insert-entity entity))))

