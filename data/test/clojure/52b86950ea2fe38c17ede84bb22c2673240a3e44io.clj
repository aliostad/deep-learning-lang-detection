(ns clj-common.io)

(defn byte2input-stream [byte-array]
  (new java.io.ByteArrayInputStream byte-array))

(defn string->input-stream [str-value]
  (new java.io.ByteArrayInputStream (.getBytes str-value)))

(def string2input-stream string->input-stream)

(defn string2reader [str-value]
  (new java.io.InputStreamReader (string2input-stream str-value)))

(defn string2buffered-reader [str-value]
  (new java.io.BufferedReader (string2reader str-value)))

(defn input-stream2reader [input-stream]
  (new java.io.InputStreamReader input-stream))

(defn input-stream->buffered-reader [input-stream]
  (new java.io.BufferedReader
       (new java.io.InputStreamReader input-stream)))

(def input-stream2buffered-reader input-stream->buffered-reader)

(defn output-stream2writer [output-stream]
  (new java.io.OutputStreamWriter output-stream))

(defn output-stream2buffered-writer [output-stream]
  (new
    java.io.BufferedWriter
    (new java.io.OutputStreamWriter output-stream)))

(defn input-stream->byte-array [input-stream]
  (org.apache.commons.io.IOUtils/toByteArray input-stream))

(def input-stream2bytes input-stream->byte-array)

(defn input-stream->string [input-stream]
  (org.apache.commons.io.IOUtils/toString input-stream))

(def input-stream2string input-stream->string)

(defn reader2buffered-reader [reader]
  (new java.io.BufferedReader reader))

(defn copy-input-to-output-stream [input-stream output-stream]
  (clojure.java.io/copy input-stream output-stream))

(defn url2input-stream [url-string]
  (let [url (new java.net.URL url-string)]
    (.openStream url)))

(defn write [output-stream bytes]
  (.write output-stream bytes))

(defn write-string [output-stream string]
  (.write output-stream (.getBytes string)))

(defn write-line [output-stream line]
  (.write output-stream (.getBytes line))
  (.write output-stream (.getBytes "\n")))

(defn read-line [buffered-reader]
  (.readLine buffered-reader))

(defn seq->input-stream
  "Creates InputStream from collection of String, Future<String, Future<InputStream>,
  InputStream. If Future is not realized, will wait for it"
  [coll]
  (let [input-stream (first coll)]
    (proxy
      [java.io.InputStream] []
      (read
        (
          []
          (.read input-stream))
        (
          [^bytes bytes]
          (proxy-super read bytes))
        (
          [^bytes bytes off len]
          (proxy-super read bytes off len))))))




; class SequenceInputStream
; converts sequence of String, InputStream,
; Future<String>, Future<InputStream>, Sequence of any

; links
; https://gist.github.com/puredanger/9cc4304a43de9a67171b
; https://clojuredocs.org/clojure.core/gen-class
; https://clojuredocs.org/clojure.core/proxy
; http://puredanger.github.io/tech.puredanger.com/2011/08/12/subclassing-in-clojure/

(gen-class
  :name "com.mungolab.common.io.SequenceInputStream"
  :extends java.io.InputStream
  :state state
  :constructors { [clojure.lang.Seqable] []}
  :exposes-methods {read readSuper}
  :prefix "seq-is-"
  :main false
  :init init)

(defn streamable->input-stream [coll]
  (let [next-streamable (first coll)
        rest-coll (rest coll)]
    (cond
      (instance? java.lang.String next-streamable)
        [(string->input-stream next-streamable) rest-coll]
      (instance? java.util.concurrent.Future next-streamable)
        (streamable->input-stream (concat [(.get next-streamable)] rest-coll))
      (instance? java.io.InputStream next-streamable)
        [next-streamable rest-coll]
      (instance? clojure.lang.Seqable next-streamable)
        (streamable->input-stream
          (concat
            next-streamable rest-coll))
      (instance? java.lang.Object next-streamable)
        [(string->input-stream (str next-streamable)) rest-coll]
      :else nil)))

(defn seq-is-init [coll]
  [[] (ref (streamable->input-stream coll))])

(defn seq-is-read
  ([this]
   (let [[current-stream coll] @(.state this)]
     (if (some? current-stream)
       (let [next-byte (.read current-stream)]
         (if
           (= next-byte -1)
           (if (empty? coll)
             -1
             (do
               (dosync
                 (ref-set
                   (.state this)
                   (streamable->input-stream coll)))
               (seq-is-read this)))
           next-byte))
       -1)))
  ([this bytes] (.readSuper this bytes))
  ([this bytes off len] (.readSuper this bytes off len)))

(defn seq->input-stream [coll]
  (new com.mungolab.common.io.SequenceInputStream coll))

