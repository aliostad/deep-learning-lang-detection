(ns elasticsearch-geocoding.rdf
  (:require [cheshire.core :as json])
  (:import (java.io ByteArrayInputStream ByteArrayOutputStream)
           (org.apache.jena.query DatasetFactory)
           (org.apache.jena.riot Lang RDFDataMgr)))

(defn jsonld->ntriples
  "Convert JSON-LD in Clojure data structure to N-Triples."
  [jsonld]
  (with-open [input-stream (ByteArrayInputStream. (.getBytes (json/generate-string jsonld)))
              output-stream (ByteArrayOutputStream.)]
    (let [dataset (DatasetFactory/create)]
      (RDFDataMgr/read dataset input-stream Lang/JSONLD)
      (RDFDataMgr/write output-stream (.getDefaultModel dataset) Lang/NTRIPLES)
      (str output-stream))))
