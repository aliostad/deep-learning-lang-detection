(ns shred.protocols
  (:require [schema.core :as s]
            [clojure.test :refer [is]]))


(def RelationSchema
  {:from s/Keyword
   :to   s/Keyword
   :on   {s/Keyword s/Keyword}})


(defprotocol IDBSchema
  "
  Schema definition to guide the shredding process.  This allows the shred library to be used with
  a range of framework conventions or custom schema logic.  How you manage and represent your
  database schema is a cross-cutting concern - it's up to you to implement this IDBSchema.
  See shred.impl.* for examples.
  "
  (-pk [_ table-name]
    "Return pk column for a table. FIXME: change to support composite keys.")
  (-rel [_ table-name rel-name]
    "Return details of a relation (join).")
  (-has-many? [_ table-name rel-name]
    "Return true if relation can return many results."))


(defn pk
  [schema table-name]
  {:pre  [(is (satisfies? IDBSchema schema))
          (is (keyword? table-name))]
   :post [(is (keyword? %))]}
  (-pk schema table-name))


(defn rel
  [schema from-table rel-name]
  {:pre  [(is (satisfies? IDBSchema schema))
          (is (keyword? from-table))
          (is (keyword? rel-name))]
   :post [(is (s/validate RelationSchema %))]}
  (-rel schema from-table rel-name))


(defn has-many?
  [schema table-name rel-name]
  {:pre [(is (satisfies? IDBSchema schema))
         (is (keyword? table-name))
         (is (keyword? rel-name))]}
  (-has-many? schema table-name rel-name))