(ns de.cr.freitonal.unittests.server.testtools
  (:use [de.cr.freitonal.server.tools])
  (:use [de.cr.freitonal.server.insert])
  (:use [de.cr.freitonal.server.tables :as table :only ()])
  
  (:use [clojure.test])
  (:use [clojure.contrib.java-utils :only (read-properties)])
  (:use [clojure.contrib.sql :as sql :only ()])
  
  (:import
   (clojure.lang RT)
   (java.sql DriverManager))

  (:import (de.cr.freitonal.usertests.client.test.data
             TestData))
  (:import (de.cr.freitonal.shared.models 
             Item 
             UID
             Instrumentation))) 
 
(defmacro tables []
  ''(classical_allocatedinstrument
      classical_allocatedinstrument_performers 
      classical_allocatedinstrumentation
      classical_allocatedinstrumentation_allocated_instruments 
      classical_catalog 
      classical_catalogtype 
      classical_composer 
      classical_instrument 
      classical_instrument_instrument_roles 
      classical_instrumentation 
      classical_instrumentation_instrument 
      classical_instrumentation_instruments 
      classical_instrumentationmember 
      classical_instrumentrole 
      classical_musickey 
      classical_operarole 
      classical_performance 
      classical_performer 
      classical_piece
      classical_piece_instrumentations 
      classical_piece_operaRoles
      classical_piece_opera_roles 
      classical_piece_parts 
      classical_piecetype
      classical_recording 
      classical_recording_performances 
      classical_recordlabel 
      classical_recordtype 
      classical_synonym 
      classical_typeplusinstrumentation))

(defn delete-all-tables []
  (apply sql/do-commands (map #(str "DELETE FROM " %) (tables))))

(defn doPurgeDB [conf-file]
  (sql/with-connection (load-file conf-file)
    (delete-all-tables)))

(defmacro dbtest [description & body]
  `(sql/with-connection db
     (table/define-tables db)
     (delete-all-tables)
     (let [~'opus (insert-catalogname TestData/Opus)
           ~'opus27-1 (insert-catalog ~'opus "27" "1")
           ~'beethoven (insert-composer TestData/Beethoven)
           ~'mozart (insert-composer TestData/Mozart)
           ~'piano (insert-instrument TestData/Piano)
           ~'violin (insert-instrument TestData/Violin)
           ~'sonata (insert-piecetype TestData/Sonata)
           ~'amajor (insert-musickey (.getVolatileMusicKey TestData/AMajor))
           ~'piano-solo (insert-instrumentation "solo piano" ~'piano)]
       ~@body)))

(defn item-vector [#^Item item]
  (vector (Integer/valueOf (.getID item)) (.getValue item)))

(defn containing? 
  ([uid s access]
    (some #(= (Integer/valueOf (.getID uid)) (access %)) s))
  ([uid s]
    (containing? uid s #(first %))))

(defn runTests [package]
  "given a clojure package as a String it runs all tests in this package"
  ;(sql/with-connection (load-file "conf/db.clj")
    (let [summary (run-tests (symbol package))]
      (zipmap (map #(str %) (keys summary)) (vals summary))))

(def db (load-file "conf/db-empty.clj"))
(table/define-tables db)