(ns hbase-clj.manage
  (:import 
    (org.apache.hadoop.hbase 
      HBaseConfiguration
      HColumnDescriptor
      HTableDescriptor
      KeyValue)
    (org.apache.hadoop.hbase.client
      Delete Get Put Scan
      Result ResultScanner 
      HBaseAdmin HTable 
      HConnection HConnectionManager)))

(defn create-table!
  "Create an hbase table"
  [cfg table-name & families]
  (let [^String table-name (name table-name)
        ^HBaseAdmin admin (HBaseAdmin. cfg)
        ^HTableDescriptor t (HTableDescriptor. table-name)]

    (if (.tableExists admin table-name)
      (throw 
        (Exception. "table exists on creation")))

    (doseq [^String s (map name families)]
      (.addFamily t (HColumnDescriptor. s)))
    
    (.createTable admin t)
    (println "table" table-name "created")))

(defn delete-table! 
  "delete an hbase table "
  [cfg table-name]
  (let [^String table-name (name table-name)
        ^HBaseAdmin admin (HBaseAdmin. cfg)]

    (.disableTable admin table-name)
    (.deleteTable admin table-name)
    (println "table" table-name "deleted")))
