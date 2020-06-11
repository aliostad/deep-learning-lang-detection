(ns cassius.api.connection.put-in
  (:require [ribol.core :refer [raise manage on]]
            [cassius.schema.outline :as sch]
            [cassius.data.outline :as c]
            [cassius.net.command
             [keyspace :as ksp]
             [column-family :as cf]
             [insert :refer [insert]]
             [mutate :refer [batch-mutate]]]))

(defn put-in-columnfamily [conn ks cf m]
  (manage
   (->> (c/outline->mutation cf m)
        (batch-mutate conn ks))
   (on :column-family-not-found e
       (let [lvl (c/column-levels m)
             t (condp = lvl
                 2 "Standard"
                 3 "Super"
                 (raise :wrong-level-number))]
         (cf/add-column-family conn ks {:name cf
                                        :column_type t})
         (put-in-columnfamily conn ks cf m)))))

(defn keyspace-insert-mutation [m]
  (->> (seq m)
       (map (fn [[cf cfm]]
              (c/outline->mutation cf cfm)))
       (apply merge)))

(defn put-in-keyspace [conn ks m]
  (manage
   (->> (keyspace-insert-mutation m)
        (batch-mutate conn ks))
   (on :column-family-not-found e
       (let [cf  (:column-family e)
             lvl (c/column-levels (get m cf))
             t (condp = lvl
                 2 "Standard"
                 3 "Super"
                 (raise :wrong-level-number))]
         (cf/add-column-family conn ks {:name cf
                                        :column_type t})
         (put-in-keyspace conn ks m)))))

(defn put-in-row [conn ks cf id m]
  (put-in-columnfamily conn ks cf {id m}))

(defn put-in-db [conn m]
  (doseq [[ks subm] m]
    (put-in-keyspace conn ks subm)))

(defn put-in
  ([conn v]
     (put-in conn [] v))
  ([conn arr v]
     (condp = (count arr)
       0 (put-in-db conn v)
       1 (apply #(put-in-keyspace conn % v) arr)
       2 (apply #(put-in-columnfamily conn %1 %2 v) arr)
       3 (apply #(put-in-row conn %1 %2 %3 v) arr)
       4 (apply #(put-in-row conn %1 %2 %3 {%4 v}) arr)
       5 (apply #(insert conn %1 %2 %3 %4 %5 v) arr)
       (raise :invalid-arguments "array selector can only have between 0 and 5 arguments"))))
