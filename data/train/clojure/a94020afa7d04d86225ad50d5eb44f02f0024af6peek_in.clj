(ns cassius.api.connection.peek-in
  (:require [cassius.common :refer [into-full]]
            [cassius.net.command.retrieve :refer [retrieve-column-family retrieve-row retrieve-column]]
            [cassius.net.command.stream :as stream]
            [cassius.api.connection.keys-in :refer [keys-in]]
            [cassius.protocols :refer [from-bytes ]]
            [cassius.types.byte-buffer]
            [cassius.data.outline :as c]
            [ribol.core :refer [raise manage on]])
  (:import [org.apache.cassandra.thrift
            Column ColumnOrSuperColumn
            CounterColumn KeySlice
            Mutation SuperColumn]))

(defn column->outline-entry
  ([^Column col]
     (column->outline-entry col nil nil))
  ([^Column col tname tvalue]
     [(from-bytes (.getName col)
                  (or tname cassius.protocols/*default-key-encoding*))
      (from-bytes (.getValue col)
                  (or tvalue cassius.protocols/*default-value-encoding*))]))

(defn supercolumn->outline-entry
  ([^SuperColumn scol]
     (supercolumn->outline-entry scol cassius.protocols/*default-key-encoding* nil))
  ([^SuperColumn scol tname tmap]
     (let [cols  (.getColumns scol)
           names (map (fn [c]
                        (from-bytes (.getName c) tname))
                      cols)
           types (map #(->> % (get tmap) first) names)]
       [(from-bytes (.getName scol) tname)
        (->> (map #(column->outline-entry %1 tname %2) cols types)
             (into-full {}))])))

(defn optioncolumn->outline-entry
  ([^ColumnOrSuperColumn opcol]
     (optioncolumn->outline-entry opcol cassius.protocols/*default-key-encoding* nil))
  ([^ColumnOrSuperColumn opcol tname tmap]
     (let [subcol (or (.getSuper_column opcol)
                      (.getColumn opcol))]
       (condp = (type subcol)
         Column
         (let [tvalue (or (->> tname
                               (from-bytes (.getName subcol))
                               (get tmap)
                               first)
                          cassius.protocols/*default-value-encoding*)]
           (column->outline-entry subcol tname tvalue))

         SuperColumn
         (supercolumn->outline-entry subcol tname tmap)))))

(defn keyslice->outline-entry
  ([^KeySlice ksl]
     (keyslice->outline-entry ksl cassius.protocols/*default-key-encoding* nil))
  ([^KeySlice ksl tname tmap]
     [(from-bytes (.getKey ksl) tname)
      (->> (.getColumns ksl)
           (map #(optioncolumn->outline-entry % tname tmap))
           (into-full {}))]))

(defn default-encodings [conn ks cf]
  [(or (-> conn :key-type (get-in [ks cf]))
       cassius.protocols/*default-key-encoding*)
   (or (-> conn :schema   (get-in [ks cf]))
       {})])

(defn peek-in-column-family [conn ks cf]
  (let [[tname tmap] (default-encodings conn ks cf) ]
    (->> (stream/stream-column-family conn ks cf)
         (map #(keyslice->outline-entry % tname tmap))
         (into-full {}))))

(defn peek-in-keyspace [conn ks]
  (let [cfs (keys-in conn [ks])]
    (->> cfs
         (map (fn [cf]
                [cf (peek-in-column-family conn ks cf)]))
         (into-full {}))))

(defn peek-in-db [conn]
  (let [ksps (keys-in conn)]
    (->> ksps
         (map (fn [ks]
                [ks (peek-in-keyspace conn ks)]))
         (into-full {}))))

(defn peek-in-row [conn ks cf row]
  (let [[tname tmap] (default-encodings conn ks cf)]
    (->> (stream/stream-row conn ks cf row)
         (map #(optioncolumn->outline-entry % tname tmap))
         (into-full {}))))

(defn peek-in-column [conn ks cf row col]
  (let [[tname tmap] (default-encodings conn ks cf)]
    (->> (retrieve-column conn ks cf row col)
         (map #(optioncolumn->outline-entry % tname tmap))
         first
         second)))

(defn peek-in-subcolumn [conn ks cf row col subcol]
  (get (peek-in-column conn ks cf row col) subcol))

(defn peek-in
  ([conn]
     (peek-in-db conn))
  ([conn arr]
     (binding [cassius.protocols/*default-value-encoding*
               (or (-> conn :value-type)
                   cassius.protocols/*default-value-encoding*)]
       (condp = (count arr)
         0 (peek-in-db conn)
         1 (apply peek-in-keyspace conn arr)
         2 (apply peek-in-column-family conn arr)
         3 (apply peek-in-row conn arr)
         4 (apply peek-in-column conn arr)
         5 (apply peek-in-subcolumn conn arr)
         (raise :invalid-arguments "array selector can only have between 0 and 5 arguments")))))
