(ns de.cr.freitonal.server.insert
  (:use [de.cr.freitonal.server.tools])
  (:use [de.cr.freitonal.server.render])
  (:use [de.cr.freitonal.server.tables :as table :only ()])

  (:use [clojure.contrib.sql :as sql :only ()])

  (:use [clojureql.core :as q :only ()])
  
  (:import (de.cr.freitonal.shared.models VolatileInstrumentation Instrumentation 
                                          VolatileItem Item 
                                          VolatilePiece Piece
                                          VolatilePiecePlusInstrumentationType PiecePlusInstrumentationType
                                          VolatileCatalog Catalog
                                          VolatileMusicKey MusicKey)))

(defn insert-simple-object [table object]
  (sql/insert-records table object)
  (sql/with-query-results res 
    ["SELECT LAST_INSERT_ID() AS id"]
    (:id (first res))))

(defmulti insert-instrument class)
(defmethod #^Item insert-instrument String [instrument-name]
  (let [instrument (VolatileItem. instrument-name)
        id (insert-simple-object :classical_instrument {:name (.getValue instrument)})]
    (Item. (str id) instrument)))
(defmethod #^Item insert-instrument VolatileItem [instrument]
  (insert-instrument (.getValue instrument)))

(defn insert-instrumentation* [nickname]
  (insert-simple-object :classical_instrumentation {:nickname nickname}))

(defn insert-instrumentation 
  ([#^String nickname & instruments]
    (insert-instrumentation (VolatileInstrumentation. nickname (into-array instruments))))
  ([#^VolatileInstrumentation instrumentation]
    (let [id (insert-instrumentation* (.getNickname instrumentation))
          originalInstrumentList (seq (.getInstruments instrumentation))
          instrumentCount (create-countmap originalInstrumentList)]
      (loop [instruments (remove-duplicates originalInstrumentList)
             counter 1]
        (when (not (empty? instruments))
          (let [instrument (first instruments)]
            (sql/insert-records :classical_instrumentationmember {:instrument_id (.getID instrument) 
                                                                  :instrumentation_id id
                                                                  :numberofinstruments (get instrumentCount instrument)
                                                                  :ordinal counter})
            (recur (rest instruments) (inc counter)))))
      (Instrumentation. (str id) instrumentation))))

(defn insert-composer [#^VolatileItem composer]
  (let [id (insert-simple-object :classical_composer {:first_name "" :middle_name "" :last_name (.getValue composer)})]
    (Item. (str id) composer)))

(defn insert-piecetype [#^VolatileItem piecetype]
  (let [id (insert-simple-object :classical_piecetype {:name (.getValue piecetype)})]
    (Item. (str id) piecetype)))

(defn #^MusicKey insert-musickey [#^VolatileMusicKey musickey]
  (let [id (insert-simple-object :classical_musickey {:base (.getBase musickey) 
                                                      :note (.getNote musickey)
                                                      :note_sort_order 1})]
    (MusicKey. (str id) musickey)))

(defmulti insert-catalogname class)
(defmethod #^Item insert-catalogname String [catalogname]
  (let [id (insert-simple-object :classical_catalogtype {:name catalogname})]
    (Item. (str id) catalogname)))
(defmethod #^Item insert-catalogname VolatileItem [catalog]
  (insert-catalogname (.getValue catalog)))

(defmulti insert-catalog (fn [param & _] (class param)))
(defmethod #^Catalog insert-catalog VolatileItem [catalogname ordinal sub-ordinal]
  (let [id (insert-simple-object :classical_catalog {:name_id (.getID catalogname) :ordinal ordinal :sub_ordinal sub-ordinal})]
    (Catalog. (str id) catalogname (create-string-from-ordinal-and-subordinal ordinal sub-ordinal))))
(defmethod #^Catalog insert-catalog VolatileCatalog [catalog]
  (let [[ordinal sub-ordinal] (create-ordinal-and-subordinal-from-string (.getOrdinal catalog))]
    (insert-catalog (.getCatalogName catalog) ordinal sub-ordinal)))

(defn #^Catalog create-catalog-from-volatile-catalog [#^VolatileCatalog vcatalog]
  (if (nil? vcatalog)
    nil
    (let [[ordinal sub-ordinal] (create-ordinal-and-subordinal-from-string (.getOrdinal vcatalog))
          res @(q/select table/catalog (q/where (and (= :name_id (.getID (.getCatalogName vcatalog)))
                                                  (= :ordinal ordinal)
                                                  (= :sub_ordinal sub-ordinal))))]
      (if (not (empty? res))
        (Catalog. (str (:id (first res))) vcatalog)
        (insert-catalog vcatalog)))))

(defn -add-attribute-to-structure
  ([structure piece attribute member-fn]
    (-add-attribute-to-structure structure (member-fn piece) attribute))
  ([structure item attribute]
    (if item
      (assoc structure attribute (.getID item))
      structure)))

(defn create-structure-for-volatile-piece
  ([#^VolatilePiece piece]
    (create-structure-for-volatile-piece piece (create-catalog-from-volatile-catalog (.getCatalog piece))))
  ([#^VolatilePiece piece #^Catalog catalog]
    (-> {}
      (-add-attribute-to-structure piece :composer_id (memfn getComposer))
      (-add-attribute-to-structure piece :piece_type_id (memfn getPieceType))
      (-add-attribute-to-structure catalog :catalog_id)
      (-add-attribute-to-structure piece :parent_id (memfn getParent))
      (-add-attribute-to-structure piece :subtitle (memfn getSubtitle))
      (-add-attribute-to-structure piece :music_key_id (memfn getMusicKey))
      (-add-attribute-to-structure piece :pub_date (memfn getPublicationDate))
      (-add-attribute-to-structure piece :type_ordinal (memfn getOrdinal)))))

(defn #^Piece insert-piece [#^VolatilePiece piece]
  (let [catalog (create-catalog-from-volatile-catalog (.getCatalog piece))
        id (insert-simple-object :classical_piece (create-structure-for-volatile-piece piece catalog))
        instrumentation (if (.hasNonVolatileInstrumentation piece)
                          (.getInstrumentationAsNonVolatile piece)
                          (insert-instrumentation (.getInstrumentation piece)))]
    (sql/insert-records :classical_piece_instrumentations {:piece_id id
                                                           :instrumentation_id (.getID instrumentation)})
    (let [result (Piece. (str id) piece)]
      (.setInstrumentation result instrumentation) ;update the instrumentation, because it became non-volatile
      (.setCatalog result catalog) ;update the catalog, because it became non-volatile
      result)))

(defn insert-piece+instrumentation-type [#^VolatilePiecePlusInstrumentationType piece+instrumentation-type]
  (let [id (insert-simple-object :classical_typeplusinstrumentation {:type_id (.getID (.getPieceType piece+instrumentation-type))
                                                                     :instrumentation_id (.getID (.getInstrumentation piece+instrumentation-type))
                                                                     :nickname (.getNickname piece+instrumentation-type)})]
    (PiecePlusInstrumentationType. (str id) piece+instrumentation-type)))
