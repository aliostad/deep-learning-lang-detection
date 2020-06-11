#_(defdeps
    [[org.clojure/clojure "1.6.0"]
     [stardog-clj "0.6"]])

;; uses lein oneoff, e.g. lein oneoff Script21.clj

(ns example
 (:require
            [stardog.core :refer :all]))

;; Types of Stardog-clj connection handling

(def prefixes "
    PREFIX oslc: <http://open-services.net/ns/core#>
    PREFIX dcterms: <http://purl.org/dc/terms/>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX oslc_qm: <http://open-services.net/ns/qm#>
    PREFIX oslc_cm: <http://open-services.net/ns/cm#>
    PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX rep_qm: <http://jazz.net/xmlns/alm/qm/v0.1/>
")

(def sparql-query (str prefixes "
    SELECT ?planUri {?planUri rdf:type oslc_qm:TestPlan}
"))


;; All methods use a database specification

(def db-spec (create-db-spec "oslc" "http://localhost:5820/" "admin" "admin" "none"))

(println "Use a datasource and with-connection-pool macro")

(def ds (make-datasource db-spec))

(println (pr-str
 (with-connection-pool [conn ds]
  (first (query conn sparql-query )))))



(println "Use the with-open for single connections")

(with-open [c (connect db-spec)]
  (println (pr-str (first (query c sparql-query )))))



(println "Manually manage a connection")

(def connection (connect db-spec))

(println (pr-str
  (first (query connection sparql-query ))))

(.close connection)






