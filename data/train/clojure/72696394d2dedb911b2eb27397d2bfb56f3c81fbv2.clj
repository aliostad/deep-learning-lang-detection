(ns adzerk.api.reporting.v2
  (:require [adzerk.api      :refer (defapi deflist defget)]
            [adzerk.helpers  :refer (clj->csharp)])
  (:import [java.util.zip GZIPInputStream]))

(defapi submit-report!
  :post "/v2/report/submit"
  {:input-data :json}
  [req]
  (doapi (clj->csharp req)))

(defapi report-status
  :get "/v2/report/status/%s"
  {:input-data :none}
  [id]
  (doapi [id] nil))

; Reports are returned by the API in gzipped form.

; This function returns the compressed input stream, which can then be written
; to a file, etc.
(defapi get-report-gzip-stream
  :get "/v2/report/get/%s"
  {:input-data  :none
   :output-data :stream}
  [id]
  (doapi [id] nil))

; This function wraps the gzip-compressed input stream in a GZIPInputStream,
; which is an uncompressed version of the original stream.
(defn get-report-stream
  [id]
  (-> (get-report-gzip-stream id) GZIPInputStream.))

; This function returns the report as a string.
(defn get-report
  [id]
  (-> (get-report-stream id) slurp))

