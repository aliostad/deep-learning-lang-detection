(ns subversion-clj.utils
  (:import
    [org.apache.commons.io.output NullOutputStream]
    [java.io File ByteArrayOutputStream ByteArrayInputStream]
    [java.util LinkedList]))

(defn normalize-path ^String [^String path]
  (if (.startsWith path "/")
    (if (= path "/") path (.substring path 1))
    path))

(defn baos
  ^ByteArrayOutputStream []
  (ByteArrayOutputStream.))

(defn baos->bais
  ^ByteArrayInputStream [^ByteArrayOutputStream bs]
  (ByteArrayInputStream. (.toByteArray bs)))

(def ^NullOutputStream null-stream (NullOutputStream.))

(defn string-array
  ^"[Ljava.lang.String;" []
  (into-array String []))

(defn linked-list
  ^LinkedList []
  (LinkedList.))
