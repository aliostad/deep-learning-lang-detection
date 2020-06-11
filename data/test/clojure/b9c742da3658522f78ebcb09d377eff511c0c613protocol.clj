(ns ribbit.protocol
  (:import (org.bouncycastle.asn1 ASN1InputStream ASN1Sequence DERUTF8String DERInteger DERObject)
           (java.io InputStream)
           (java.lang.ClassCastException)))

;; Oh boy here we go: the Clojure RIBBIT protocol decoder.
;; Check out this cool RFC on the RIBBIT protocol: http://frog.tips/api/1/

(defn- create-tip
  "Create a FROG tip. Croaks are represented as a sequence of tips."
  [number tip]
  {:number number
   :tip    tip})

(defn- object-from-stream
  "Create a DERObject from a stream. This object may or may not be iterable."
  [^InputStream stream]
  (.readObject (ASN1InputStream. stream)))

(defn- object-seq-from-object
  "Treat the DERObject as iterable and convert it a sequence of DERObjects."
  [^DERObject der]
  (enumeration-seq
    (.getObjects (cast ASN1Sequence der))))

(defn- decode-from-stream
  "Decode a part of the RIBBIT protocol from a stream."
  [decoder-func stream]
  (try
    (-> stream
        object-from-stream
        object-seq-from-object
        decoder-func)
    ; These shouldn't bubble up
    (catch ClassCastException _ nil)))

(defn- decode-tip
  "Decode a RIBBIT tip from a sequence of ASN.1 objects."
  [der-objects]
  (let [[first second] der-objects
        number (.getValue (cast DERInteger first))
        tip (.getString (cast DERUTF8String second))]
    (create-tip number tip)))

(defn- decode-croak
  "Decode an entire RIBBIT croak from a sequence of ASN.1 objects."
  [der-objects]
  ; Force this to evaluate now and throw any exceptions.
  ; There's probably a more idiomatic way to handle this.
  (doall (map #(decode-tip (object-seq-from-object %1)) der-objects)))

;; RIBBIT decoder functions that operate on streams.
;; These return nil on any decoding error to keep things idomatic - I think?

(defn decode-tip-from-stream
  "Decode a RIBBIT tip"
  [stream]
  (decode-from-stream decode-tip stream))

(defn decode-croak-from-stream
  "Decode a RIBBIT croak"
  [stream]
  (decode-from-stream decode-croak stream))