(ns de.cr.freitonal.server.search
  (:use [de.cr.freitonal.server.tools])
  (:use [de.cr.freitonal.server.javainterop])  
  (:use [de.cr.freitonal.server.render])
  (:use [de.cr.freitonal.server.sql-engine])
 
  (:use [clojure.contrib.json :only (json-str)])
  
  (:import 
    (java.util ArrayList)
    (de.cr.freitonal.shared.models PieceSkeleton PieceList)))

(defn process-search-params [searchParams]
  (if (contains? searchParams "piece-instrumentations__instrument")
    (assoc searchParams "piece-instrumentations__instrument" 
      (create-countmap (searchParams "piece-instrumentations__instrument")))
    searchParams))

(defn render-composer [rec] 
  (vector
    (:id rec)
    (str (:last_name rec) 
      (if (not-empty (:first_name rec)) (str ", " (:first_name rec))) 
      (if (not-empty (:middle_name rec)) (str " " (:middle_name rec))))))

(defn search-composer [searchParams]
  (run-search-query
    {:select "DISTINCT composer.id, composer.first_name, composer.middle_name, composer.last_name" 
     :from ["classical_composer composer", "classical_piece piece"]
     :initial-loading-from ["classical_composer composer"]
     :where "piece.composer_id = composer.id"}
    render-composer searchParams true))

(defn render-name [rec] 
  (vector (:id rec) (:name rec)))

(defn search-label [searchParams]
  (run-search-query 
    {:select "DISTINCT label.id, label.name"
     :from ["classical_recordlabel label", "classical_recording recording", 
            "classical_piece piece", "classical_performance performance", "classical_recording_performances"]
     :initial-loading-from ["classical_recordlabel label"]
     :where "recording.label_id = label.id
       AND classical_recording_performances.recording_id = recording.id
       AND classical_recording_performances.performance_id = performance.id
       AND performance.piece_id = piece.id"} 
    render-name searchParams))

(defn render-subtitle [rec]
  (vector (:subtitle rec) (:subtitle rec)))

(defn search-subtitle [searchParams]
  (run-search-query 
    {:select "DISTINCT piece.subtitle"
     :from ["classical_piece piece"]}
    render-subtitle searchParams))

(defn search-recording-type [searchParams]
  (run-search-query
    {:select "DISTINCT type.id, type.name"
     :from ["classical_recording recording", "classical_recordtype type", 
            "classical_piece piece", "classical_performance performance",
            "classical_recording_performances"]
     :initial-loading-from ["classical_recordtype type"]
     :where "recording.type_id = type.id
       AND classical_recording_performances.recording_id = recording.id
       AND classical_recording_performances.performance_id = performance.id
       AND performance.piece_id = piece.id"} 
    render-name searchParams))

(defn render-performance-location [rec] 
  (vector (:location rec) (:location rec)))

(defn search-performance-location [searchParams]
  (run-search-query
   {:select "DISTINCT performance.location"
    :from ["classical_performance performance", "classical_piece piece"]
    :initial-loading-from ["classical_performance performance"]
    :where "performance.location IS NOT NULL AND performance.location <> ''
       AND performance.piece_id = piece.id"
    :initial-loading-where "performance.location IS NOT NULL AND performance.location <> ''"} 
   render-performance-location searchParams))

(defn render-performance-date [rec]
  (vector (:date rec) (:date rec)))

(defn search-performance-date [searchParams]
  (run-search-query
    {:select "DISTINCT performance.date"
     :from ["classical_performance performance", "classical_piece piece"]
     :initial-loading-from ["classical_performance performance"]
     :where "performance.date IS NOT NULL AND performance.date <> ''
       AND performance.piece_id = piece.id"
     :initial-loading-where "performance.date IS NOT NULL AND performance.date <> ''"}
    render-performance-date searchParams))

(defn render-piece-type_ordinal [rec]
  (vector (:type_ordinal rec) (:type_ordinal rec)))

(defn search-piece-type_ordinal [searchParams]
  (run-search-query
    {:select "DISTINCT piece.type_ordinal"
     :from ["classical_piece piece"]}
    render-piece-type_ordinal searchParams))


(defn get-possible-null-field-from-piece [field searchParams]
  (let [where (str "piece." field " IS NULL")]
    (run-search-query
      {:select (str "DISTINCT piece." field)
       :from ["classical_piece piece"]
       :initial-loading-where where 
       :where where}
    (fn [_] (vector nil nil)) searchParams)))

(defn search-piece-piece_type [searchParams]
  (concat 
    (get-possible-null-field-from-piece "piece_type_id" searchParams)
    (run-search-query
      {:select "DISTINCT piecetype.id, piecetype.name"
       :initial-loading-from ["classical_piecetype piecetype"]
       :from ["classical_piecetype piecetype", "classical_piece piece"]
       :where "piece.piece_type_id = piecetype.id"}
      render-name searchParams)))

(defn search-performance-performers [searchParams]
  (run-search-query
    {:select "DISTINCT performer.id, performer.first_name, performer.middle_name, performer.last_name"
     :from ["classical_performer performer", "classical_performance performance", 
            "classical_allocatedinstrument_performers", "classical_allocatedinstrumentation_allocated_instruments",
            "classical_piece piece"]
     :initial-loading-from ["classical_performer performer"]
     :where "classical_allocatedinstrument_performers.performer_id = performer.id
       AND classical_allocatedinstrument_performers.allocatedinstrument_id = classical_allocatedinstrumentation_allocated_instruments.allocatedinstrument_id
       AND classical_allocatedinstrumentation_allocated_instruments.allocatedinstrumentation_id = performance.instrumentation_id
       AND performance.piece_id = piece.id"}
    render-composer searchParams))

(defn render-instrumentation [rec]
  (hash-map :id (:id rec) 
            :nickname (:nickname rec)
            :instruments (vector (vector (:instrument_id rec) (:name rec) (:numberofinstruments rec)))))

(defn merge-instrumentRecords-into-instrumentations 
  ([instrumentRecords]
    (if (empty? instrumentRecords)
      '()
      (merge-instrumentRecords-into-instrumentations (rest instrumentRecords) (hash-map (:id (first instrumentRecords)) (first instrumentRecords)))))
  ([instrumentRecords acc]
    (if (empty? instrumentRecords)
      (vals acc)
      (let [rec (first instrumentRecords)
            id (:id rec)
            new-acc (if (contains? acc id)
                      (assoc acc id (assoc rec :instruments (concat (get-in acc [id :instruments]) (:instruments rec))))
                      (assoc acc id rec))]
        (merge-instrumentRecords-into-instrumentations (rest instrumentRecords) new-acc)))))

(defn search-piece-instrumentations [searchParams]
  (let [instrumentRecords (run-search-query
                            {:select "DISTINCT classical_instrumentation.id, 
                                               classical_instrumentation.nickname, 
                                               instruments.instrument_id,
                                               instruments.numberOfInstruments,
                                               instrument.name"
                             :from ["classical_piece piece", "classical_instrumentation", "classical_piece_instrumentations",
                                    "classical_instrumentationmember instruments", "classical_instrument instrument"]
                             :initial-loading-from ["classical_instrumentation", "classical_instrumentationmember instruments", "classical_instrument instrument"]
                             :where "classical_piece_instrumentations.piece_id = piece.id
                               AND classical_piece_instrumentations.instrumentation_id = classical_instrumentation.id
                               AND instruments.instrumentation_id = classical_instrumentation.id
                               AND instruments.instrument_id = instrument.id"
                             :initial-loading-where "instruments.instrumentation_id = classical_instrumentation.id
                               AND instruments.instrument_id = instrument.id"
                             :order "instruments.ordinal"}
                            render-instrumentation searchParams)]
    (merge-instrumentRecords-into-instrumentations instrumentRecords)))

(defn search-piece-music-key [searchParams]
  (concat 
    (get-possible-null-field-from-piece "music_key_id" searchParams)
    (run-search-query
      {:select "DISTINCT classical_musickey.id, classical_musickey.generated_title AS name"
       :from ["classical_musickey", "classical_piece piece"]
       :initial-loading-from ["classical_musickey"]
       :where "piece.music_key_id = classical_musickey.id"}
      render-name searchParams)))

(defn search-piece-catalog-name [searchParams]
  (let [subselect "(SELECT classical_catalogtype.id AS id, 
                            classical_catalogtype.name AS name, 
                            classical_catalog.id AS catalog_id 
                     FROM classical_catalogtype, classical_catalog 
                     WHERE classical_catalog.name_id = classical_catalogtype.id) AS catalog"
        sql {:select "DISTINCT catalog.id, catalog.name"
            :from [subselect, "classical_piece piece"]
            :initial-loading-from [subselect]
            :where "piece.catalog_id = catalog.catalog_id"}]
    (concat 
      (get-possible-null-field-from-piece "catalog_id" searchParams)
      (run-search-query sql render-name searchParams))))

(defn render-catalog-number [rec]
  (vector 
    (:id rec) 
    (create-string-from-ordinal-and-subordinal (:ordinal rec) (:sub_ordinal rec)))) 

(defn search-piece-catalog-number [searchParams]
  (concat 
    (get-possible-null-field-from-piece "catalog_id" searchParams)
    (run-search-query
      {:select "DISTINCT classical_catalog.id, classical_catalog.ordinal, classical_catalog.sub_ordinal"
       :from ["classical_catalog", "classical_piece piece"]
       :where "piece.catalog_id = classical_catalog.id"
       :initial-loading-where "piece.catalog_id = classical_catalog.id"
       :order "classical_catalog.ordinal, classical_catalog.sub_ordinal"}
      render-catalog-number searchParams)))

(defn search-piece-type+instrumentation [searchParams]
  (run-search-query
    {:select "DISTINCT classical_typeplusinstrumentation.id, classical_typeplusinstrumentation.nickname AS name"
     :from ["classical_typeplusinstrumentation", "classical_piece piece", "classical_piece_instrumentations"]
     :initial-loading-from ["classical_typeplusinstrumentation"]
     :where "classical_typeplusinstrumentation.type_id = piece.piece_type_id
       AND classical_typeplusinstrumentation.instrumentation_id = classical_piece_instrumentations.instrumentation_id"}
    render-name searchParams))

(defn render-publication-date [rec]
  (vector (:pub_date rec) (:pub_date rec)))

(defn search-piece-publication-date [searchParams]
  (run-search-query 
    {:select "DISTINCT piece.pub_date"
     :from ["classical_piece piece"]}
    render-publication-date searchParams))

(defn search [searchParams]
  (let [processedSearchParams (process-search-params searchParams)]
    (json-str (hash-map 
                "piece-composer" (search-composer processedSearchParams)
                "piece-subtitle" (search-subtitle processedSearchParams)
                "piece-type_ordinal" (search-piece-type_ordinal processedSearchParams)
                "piece-piece_type" (search-piece-piece_type processedSearchParams)
                "piece-instrumentations" (search-piece-instrumentations processedSearchParams)
                "piece-music_key" (search-piece-music-key processedSearchParams)
                "piece-catalog__name" (search-piece-catalog-name processedSearchParams)
                "piece-catalog__number" (search-piece-catalog-number processedSearchParams)
                "piece-type+instrumentation" (search-piece-type+instrumentation processedSearchParams)
                "piece-publication_date" (search-piece-publication-date processedSearchParams)
                
                "performance-location" (search-performance-location processedSearchParams)
                "performance-date" (search-performance-date processedSearchParams)
                "performance-instrumentation__allocated_instruments__performers" (search-performance-performers processedSearchParams)
                
                "recording-label" (search-label processedSearchParams)
                "recording-type" (search-recording-type processedSearchParams)))))

(defn render-piece-title [rec]
  (let [piece (PieceSkeleton. (str-nil (:id rec)))]
    (.setComposerID  piece (str-nil (:composer_id rec)))
    (.setCatalogID piece (str-nil (:catalog_id rec)))
    (.setCatalogNameID piece (str-nil (:name_id rec)))
    (.setMusicKeyID piece (str-nil (:music_key_id rec)))
    (.setTypeID piece (str-nil (:piece_type_id rec)))
    (.setSubtitle piece (str-nil (:subtitle rec)))
    (.setParentID piece (str-nil (:parent_id rec)))
    (.setInstrumentationID piece (str-nil (:instrumentation_id rec)))
    (.setPublicationDate piece (str-nil (:pub_date rec)))
    piece))

(defn list-pieces [searchParams]
  (let [processedSearchParams (process-search-params searchParams)]
    (reduce #(do (. %1 add %2) %1) (PieceList.) 
      (run-search-query 
        {:select "piece.*, classical_piece_instrumentations.instrumentation_id, classical_catalog.name_id"
         :from ["classical_piece piece", "classical_piece_instrumentations", "classical_catalog"]
         :where "classical_piece_instrumentations.piece_id = piece.id
                   AND piece.catalog_id = classical_catalog.id"
         :initial-loading-where "classical_piece_instrumentations.piece_id = piece.id
                                   AND piece.catalog_id = classical_catalog.id"}
        render-piece-title searchParams))))  