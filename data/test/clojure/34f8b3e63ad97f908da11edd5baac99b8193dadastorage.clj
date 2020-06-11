(ns patalyze.storage
  (:require [environ.core   :refer [env]]
            [aws.sdk.s3     :as s3]
            [clojure.string :as s])
  (:import [java.io File ByteArrayInputStream ByteArrayOutputStream]
           [java.util.zip GZIPInputStream GZIPOutputStream]
           [org.apache.commons.io IOUtils]))


(def bucket "patalyze")
(def cred {:access-key (env :aws-key)
           :secret-key (env :aws-secret)})

(defn str->gzipped-bytes [str]
  (with-open [out (ByteArrayOutputStream.)
              gzip (GZIPOutputStream. out)]
    (do
      (.write gzip (.getBytes str))
      (.finish gzip)
      (.toByteArray out))))

(defn gzipped-input-stream->str [input-stream encoding]
  (with-open [out (ByteArrayOutputStream.)]
    (IOUtils/copy (GZIPInputStream. input-stream) out)
    (.close input-stream)
    (.toString out encoding)))

(defn cache [[ident applications]]
  (let [string-val (pr-str applications)
        key        (str "applications/" (name ident) ".edn.gz")
        cache      (str (env :data-dir ) "/cache/applications/" (name ident) ".edn.gz")
        gzipped    (str->gzipped-bytes string-val)
        in-stream  (ByteArrayInputStream. gzipped)]
    (with-open [out (clojure.java.io/output-stream cache)]
      (clojure.java.io/copy in-stream out))))

(defn upload-cached [ident]
  (let [key        (str "applications/" (name ident) ".edn.gz")
        cached     (str (env :data-dir ) "/cache/applications/" (name ident) ".edn.gz")]
    (with-open [in-stream (clojure.java.io/input-stream cached)]
      (s3/put-object cred bucket key in-stream {:content-encoding "gzip"
                                                :content-length (.length (File. cached))}))))

(defn download [ident]
  (let [key      (str "applications/" ident ".edn.gz")
        cache    (str (env :data-dir ) "/cache/applications/" ident ".edn.gz")
        get-obj  #(clojure.java.io/input-stream (:content (s3/get-object cred bucket key)))]
    (if-not (.exists (clojure.java.io/file cache))
      (with-open [content (get-obj)
                  out     (clojure.java.io/output-stream cache)]
        (clojure.java.io/copy content out)))))
     ;; (read-string (gzipped-input-stream->str
     ;;               (clojure.java.io/input-stream cache)
     ;;               "UTF-8"))

(defn load-cached [ident]
  (let [cache    (str (env :data-dir ) "/cache/applications/" ident ".edn.gz")]
    (if (.exists (clojure.java.io/file cache))
      (read-string (gzipped-input-stream->str
                   (clojure.java.io/input-stream cache)
                   "UTF-8")))))

(defn list-applications []
  (try
    (map :key
         (:objects (s3/list-objects cred bucket {:prefix "applications/"})))
    (catch com.amazonaws.AmazonClientException e [])))

(comment
  (list-applications)

  (map :key
       (:objects (s3/list-objects cred bucket)))
  (slurp (:content (s3/get-object cred bucket "multipart-stream-test")))

  (def st
    (ByteArrayInputStream.
     (.getBytes "TEST" "UTF-8")))

  (map #(apply str %) (partition-all (* 5 1024 1024) (repeat "xxx ")))
  (str \a \b)

  (repeat 1000 "xxx ")
  (def is (->> (repeat 10000 "xxx ")
               (map #(java.io.ByteArrayInputStream. (.getBytes %)))
               (clojure.lang.SeqEnumeration.)
               (java.io.SequenceInputStream.)))

  (s3/put-multipart-stream cred bucket "multipart-stream-test" is)
  (-> is (clojure.java.io/reader) ((fn [r] (apply str (map char (repeatedly 20 #(.read r)))))))
  (slurp is)
  (-> *e ex-data :object :body slurp)
  (s3/delete-object cred bucket "applications2004.edn"))
