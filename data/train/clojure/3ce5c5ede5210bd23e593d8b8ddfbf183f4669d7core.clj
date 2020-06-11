(ns clj-lzma.core
  (:import [java.io BufferedInputStream BufferedOutputStream])
  (:import [lzma.sdk.lzma Encoder Decoder])
  (:import [lzma.streams LzmaInputStream LzmaOutputStream LzmaOutputStream$Builder])
  (:require [clojure.java.io :as io]))

(defn compress [from to]
  (with-open [in (BufferedInputStream. (io/input-stream from))
              out (-> (LzmaOutputStream$Builder. (BufferedOutputStream. (io/output-stream to)))
                       #_(.useMaximalDictionarySize)
                       #_(.useEndMarkerMode true)
                       #_(.useBT4MatchFinder)
                       (.build))]
    (io/copy in out)))

(defn decompress [from to]
  (with-open [in (LzmaInputStream. (BufferedInputStream. (io/input-stream from)) (Decoder.))
              out (BufferedOutputStream.(io/output-stream to))]
    (io/copy in out)))
