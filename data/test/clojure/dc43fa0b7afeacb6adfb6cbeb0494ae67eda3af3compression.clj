; Copyright (c) Gunnar Völkel. All rights reserved.
; The use and distribution terms for this software are covered by the
; Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
; which can be found in the file epl-v1.0.txt at the root of this distribution.
; By using this software in any fashion, you are agreeing to be bound by
; the terms of this license.
; You must not remove this notice, or any other, from this software.

(ns frost.compression
  (:import
    (java.io OutputStream InputStream)
    (java.util.zip DeflaterOutputStream Deflater InflaterInputStream Inflater)
    (org.xerial.snappy SnappyOutputStream SnappyInputStream))
  (:require
    [clojure.options :refer [defn+opts]]))



(defn+opts wrap-compression
  "Returns an Input-/OutputStream that uses compression for the given Input-/OutputStream.
  <no-wrap>For compression algorithm :gzip, set to true for GZIP compatible compression</>
  <compression-level>For compression algorithm :gzip, range 0,1-9 (no compression, best speed - best compression)</>
  <compression-algorithm>Specifies the compression algorithm to use. Snappy is default since it is pretty fast when reading and writing.</>"
  [stream | {no-wrap true, compression-level (choice 9 0 1 2 3 4 5 6 7 8), compression-algorithm (choice :snappy :gzip)}]
  (cond
    (instance? OutputStream stream)
      (case compression-algorithm
        :gzip (DeflaterOutputStream. ^OutputStream stream, (Deflater. (int compression-level), (boolean no-wrap))),
        :snappy (SnappyOutputStream. ^OutputStream stream))
    (instance? InputStream stream)
      (case compression-algorithm
        :gzip (InflaterInputStream.  ^InputStream  stream, (Inflater. (boolean no-wrap))),
        :snappy (SnappyInputStream. ^InputStream stream))
    :else 
      (throw (IllegalArgumentException. (format "Expected InputStream or OutputStream but found %s!" (type stream))))))