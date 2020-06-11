(ns ^{:author "Marco Yuen <marcoy@gmail.com>"}
  ebtoolkits.core
  (:require [clojure.core.match :refer [match]]
            [clojure.pprint :refer [pprint]]
            [rx.lang.clojure.interop :as rx])
  (:import [java.io InputStream OutputStream FileInputStream StringWriter File
                    PipedOutputStream PipedInputStream]
           [java.net URL URI]
           [org.apache.tika Tika]
           [org.apache.tika.io TikaInputStream]
           [org.apache.tika.metadata Metadata]
           [org.apache.tika.parser AutoDetectParser ParseContext]
           [org.apache.tika.sax BodyContentHandler]
           [rx Observable]
           [rx.subscriptions Subscriptions]))


;;;
;;; Content
;;;
(defn ^Observable get-observable
  [in]
  (Observable/create
    (rx/fn [observer]
      (let [outstream (proxy [java.io.OutputStream] []
                        (close [] (.onCompleted observer))
                        (write
                          ([b] (.onNext observer (String. b)))
                          ([b offset len]
                            (.onNext observer
                                     (-> (java.util.Arrays/copyOfRange ^bytes b
                                                                       offset
                                                                       (+ offset len))
                                         String.)))))

            ;; Subscriptions
            subscription (Subscriptions/create (rx/action []))]
        (.start (Thread. (fn []
                           (try
                             (let [stream (TikaInputStream/get in)]
                               (.parse (AutoDetectParser.)
                                       stream
                                       (BodyContentHandler. outstream)
                                       (Metadata.)
                                       (ParseContext.))
                               (.close stream)
                               (.close outstream))
                             (catch Exception e
                               (.onError observer e))))))
        subscription))))


(defn ^String tika-get-content
  [in]
  (try
    (let [stream (TikaInputStream/get in)
          parser (AutoDetectParser.)
          writer (StringWriter.)
          chandler (BodyContentHandler. writer)
          metadata (Metadata.)
          pcontext (ParseContext.)
          _ (.parse parser stream chandler metadata pcontext)]
      (.close stream)
      (.toString writer))
    (catch Exception e
      nil)))


(defn ^InputStream tika-get-content-stream
  [in]
  (try
    (let [stream (TikaInputStream/get in)
          parser (AutoDetectParser.)
          outstream (PipedOutputStream.)
          chandler (BodyContentHandler. outstream)
          metadata (Metadata.)
          pcontext (ParseContext.)
          inputstream (PipedInputStream. outstream)]
      ; parse in a separate thread.
      (.start (Thread. (fn []
                         (.parse parser stream chandler metadata pcontext)
                         (.close stream)
                         (.close outstream))))
      inputstream)
    (catch Exception e
      nil)))


(defprotocol Content
  (^String content [this] "Return the content as a String")
  (^InputStream content-stream [this] "Return the content as an InputStream")
  (^Observable content-observable [this] "Return an Observable from RxJava"))


(extend-protocol Content
  String
  (^String content [s] (tika-get-content (File. s)))
  (^InputStream content-stream [s] (tika-get-content-stream (File. s)))
  (^Observable content-observable [s] (get-observable (File. s)))

  File
  (^String content [file] (tika-get-content file))
  (^InputStream content-stream [file] (tika-get-content-stream file))
  (^Observable content-observable [file] (get-observable file))

  URL
  (^String content [url] (tika-get-content url))
  (^InputStream content-stream [url] (tika-get-content-stream url))
  (^Observable content-observable [url] (get-observable url))

  URI
  (^String content [uri] (tika-get-content uri))
  (^InputStream content-stream [uri] (tika-get-content-stream uri))
  (^Observable content-observable [uri] (get-observable uri))

  InputStream
  (^String content [is] (tika-get-content is))
  (^InputStream content-stream [is] (tika-get-content-stream is))
  (^Observable content-observable [is] (get-observable is)))


;;;
;;; Metadata using pantomime
;;;
(defprotocol Mime
  (^String mime-type [this]))


(extend-protocol Mime
  String
  (^String mime-type [s] (-> (Tika.) (.detect (File. s))))

  File
  (^String mime-type [file] (-> (Tika.) (.detect file)))

  URL
  (^String mime-type [url] (-> (Tika.) (.detect url)))

  URI
  (^String mime-type [uri] (-> (Tika.) (.detect (.toURL uri))))

  InputStream
  (^String mime-type [is] (-> (Tika.) (.detect is))))


;;;
;;; Main
;;;
(defn print-stream
  [^InputStream s]
  (let [reader (clojure.java.io/reader s)]
    (doseq [line (line-seq reader)]
      (println line))
    (.close s)))


(defn wrong-word-count
  "XXX WARNING XXX
  This is not accurate. Because the parser calls write, which in turn, calls
  onNext based on some buffer size. It means that it can split a single word
  into two. This is to demonstrate the observable feature."
  []
  (let [o (content-observable (File. "test.txt"))]
    (-> o
        (.map (rx/fn [v] (as-> v coll
                           (clojure.string/split coll #"\s")
                           (filter #(> (count %) 0) coll))))
        (.reduce 0 (rx/fn [acc, v] (+ acc (count v))))
        (.subscribe (rx/action [v] (pprint v))
                    (rx/action [e] (.printStackTrace e))))))


(defn -main
  [& args]
  (let [f (first args)]
    (print (content f))
    (println "========================")
    (print-stream (content-stream f))))
