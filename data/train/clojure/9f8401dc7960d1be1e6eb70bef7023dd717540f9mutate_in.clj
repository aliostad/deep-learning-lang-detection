(ns cassius.api.connection.mutate-in
  (:require [cassius.net.command.keyspace :as ksp]
            [cassius.net.command.column-family :as cf]
            [cassius.net.command.delete :refer [delete-column-mutation
                                                delete-sub-column-mutation]]
            [cassius.net.command.mutate :refer [batch-mutate]]
            [cassius.data.outline :as c]
            [cassius.api.connection.put-in :refer [keyspace-insert-mutation]]
            [cassius.protocols :refer [to-bbuff]]
            [ribol.core :refer [raise manage on]]))

(defn mutate-in [conn ks add-map del-vec]
  (manage
   (let [t-ms    (System/currentTimeMillis)
         inserts (keyspace-insert-mutation add-map)
         deletes (->> del-vec
                      (map (fn [[cf row & more]]
                             (condp = (count more)
                               1 [(to-bbuff row) {cf [(delete-column-mutation more t-ms)]}]
                               2 [(to-bbuff row) {cf [(delete-sub-column-mutation (first more) (next more) t-ms)]}])))
                      (into {}))]
     (batch-mutate conn ks (merge inserts deletes)))
   (on :column-family-not-found e
       (let [cf  (:column-family e)
             lvl (c/column-levels (get add-map cf))
             t (condp = lvl
                 2 "Standard"
                 3 "Super"
                 (raise :wrong-level-number))]
         (cf/add-column-family conn ks {:name cf
                                        :column_type t})
         (mutate-in conn ks add-map del-vec)))))

;;  List<Mutation> insertion_list = new ArrayList<Mutation>();

;;  Column col_to_add = new Column(ByteBuffer.wrap(("name").getBytes("UTF8")), ByteBuffer.wrap(("value").getBytes("UTF8")),System.currentTimeMillis());

;;  Mutation mut = new Mutation();
;;  mut.setColumn_or_supercolumn(new ColumnOrSuperColumn().setColumn(col_to_add));
;;  insertion_list.add(mut);

;;  Map<String,List<Mutation>> columnFamilyValues = new HashMap<String,List<Mutation>>();
;;  columnFamilyValues.put("columnFamily",insertion_list);

;;  Map<ByteBuffer,<String,List<Mutation>>> rowDefinition = new HashMap<ByteBuffer,<String,List<Mutation>>>();
;;  rowDefinition.put(ByteBuffer.wrap(("key").getBytes("UTF8")), columnFamilyValues);

;;  client.batch_mutate(rowDefinition,ConsistencyLevel.ONE);

;; col_to_add -> col_or_super_col -> mutation -> insert_list -> columnFamilyValues -> rowDefinition -> batch_mutate
