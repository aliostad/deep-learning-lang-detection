(ns dcm2mongo.dcm-parser
  (:import (java.io File ByteArrayOutputStream FilterOutputStream OutputStream FileInputStream)
           (org.dcm4che3.io DicomInputStream DicomInputStream$IncludeBulkData)
           (org.dcm4che3.json JSONWriter)
           (javax.json Json))
  (:use [dcm2mongo.personal-anonymizer]
        [clojure.walk])
  (:require [clojure.tools.logging :as log]
            [cheshire.core :as json :only [parse-string]])
  (:gen-class)
  )

(defn- json-generator [^OutputStream out]
  (.createGenerator
    (Json/createGeneratorFactory (hash-map)) out))

(defn- setDicomIsConfig [^DicomInputStream in]
  (doto in
    (.setBulkDataDirectory nil)
    (.setBulkDataFilePrefix "blk")
    (.setBulkDataFileSuffix nil)
    (.setConcatenateBulkDataFiles false)
    (.setIncludeBulkData DicomInputStream$IncludeBulkData/NO)))

;/org/dcm4che/dcm4che-dict/3.3.7/dcm4che-dict-3.3.7.jar!/dataelements.xml tag
(defn- dcm-parse [^DicomInputStream in out]
  (let [json-gen (json-generator out)]
    (doto (setDicomIsConfig in)
      (.setDicomInputHandler (JSONWriter. json-gen))
      (.readDataset -1 -1))
    (.flush json-gen)))

(defn- remove-inlineBinary [obj]
  (let [f (fn [[k v]] (if (= :InlineBinary k) [k nil] [k v]))]
    (postwalk (fn [x] (if (map? x) (into {} (map f x)) x)) obj)))

(defn- read-file [^File f ^String encode]
  (with-open [byte-array (ByteArrayOutputStream.)
              output (FilterOutputStream. byte-array)
              f-stream (FileInputStream. f)]
    (try
      (dcm-parse (DicomInputStream. f-stream) output)
      (remove-inlineBinary (json/parse-string (.toString byte-array encode) true))
      (catch Exception e (log/error (str f ":" (.getLocalizedMessage e))) nil))))

(defn dcm2parse [^File f]
  (log/debug "parse:" f)
  (when-let [obj (read-file f "UTF-8")]
    (attrbute-anonymization obj)))

