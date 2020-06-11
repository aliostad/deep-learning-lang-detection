(ns de.cr.freitonal.server.insert-frontend
  (:use [de.cr.freitonal.server.insert])
  (:use [de.cr.freitonal.server.tables :as table :only ()])

  (:use [clojure.contrib.sql :as sql :only ()])
  
  (:import (de.cr.freitonal.shared.models VolatileInstrumentation Instrumentation 
                                          VolatileItem Item 
                                          VolatilePiece Piece
                                          VolatilePiecePlusInstrumentationType PiecePlusInstrumentationType
                                          VolatileCatalog Catalog)))

(defn execute-with-db-connection [conf-file create-function]
  (let [db (load-file conf-file)]
    (table/define-tables db)
    (sql/with-connection db
      (create-function))))

(defn doCreateInstrument [conf-file #^VolatileItem instrument]
  (sql/with-connection (load-file conf-file)
    (insert-instrument instrument)))

(defn doCreateInstrumentation [conf-file #^VolatileInstrumentation instrumentation]
  (execute-with-db-connection conf-file #(insert-instrumentation instrumentation)))

(defn doCreateComposer [conf-file #^VolatileItem composer]
  (sql/with-connection (load-file conf-file)
    (insert-composer composer)))

(defn doCreatePieceType [conf-file #^VolatileItem piecetype]
  (sql/with-connection (load-file conf-file)
    (insert-piecetype piecetype)))

(defn doCreateCatalogName [conf-file #^VolatileItem catalogName]
  (sql/with-connection (load-file conf-file)
    (insert-catalogname catalogName)))

(defn #^Catalog doCreateCatalog [conf-file #^VolatileCatalog catalog]
  (sql/with-connection (load-file conf-file)
    (insert-catalog catalog)))

(defn #^Piece doCreatePiece [conf-file #^VolatilePiece piece]
  (execute-with-db-connection conf-file #(insert-piece piece)))

