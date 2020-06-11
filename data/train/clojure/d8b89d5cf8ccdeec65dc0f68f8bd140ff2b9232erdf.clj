(ns rdf-path-examples.rdf
  (:import [java.io InputStream]
           [org.apache.jena.rdf.model Model]
           [org.apache.jena.query DatasetFactory]
           [org.apache.jena.riot Lang RDFDataMgr]))

(defn ^Model input-stream->rdf-model
  "Convert `input-stream` serialized in `syntax` into a Jena Model."
  [syntax
   ^InputStream input-stream]
  (let [dataset (DatasetFactory/create)]
    (RDFDataMgr/read dataset input-stream syntax)
    (.getDefaultModel dataset)))

(def json-ld->rdf-model
  "Convert JSON-LD InputStream into a Jena Model."
  (partial input-stream->rdf-model Lang/JSONLD))

(def turtle->rdf-model
  "Convert Turtle InputStream into a Jena Model."
  (partial input-stream->rdf-model Lang/TURTLE))
