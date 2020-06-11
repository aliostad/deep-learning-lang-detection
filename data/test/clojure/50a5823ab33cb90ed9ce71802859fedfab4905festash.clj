(ns pug.stash
  (:require [taoensso.nippy :as nippy]))

(deftype ValStash [filename val-fn]
  clojure.lang.IDeref
  (deref [this]
    (val-fn filename)))

(deftype SeqStash [filename seq-fn]
  clojure.lang.IDeref
  (deref [this]
    (seq-fn filename))
  clojure.lang.Seqable
  (seq [this]
    (seq-fn filename)))

(defn temp-filename []
  (let [file (java.io.File/createTempFile "stash" "")]
    (.deleteOnExit file)
    (.getAbsolutePath file)))

(defn nippy-val-stash
  ([val]
     (nippy-val-stash val (temp-filename)))
  ([val filename]
     (with-open [stream (java.io.DataOutputStream. (clojure.java.io/output-stream filename))]
       (nippy/freeze-to-stream! stream val))
     (ValStash. filename #(nippy/thaw-from-stream! (java.io.DataInputStream. (clojure.java.io/input-stream %))))))

(defn- freeze-many-to-stream! [seq stream]
  (doseq [val seq]
    (nippy/freeze-to-stream! stream val)))

(defn- thaw-many-from-stream! [stream]
  (lazy-seq
   (try
     (let [head (nippy/thaw-from-stream! stream)]
       (cons head (thaw-many-from-stream! stream)))
     (catch java.io.EOFException _
       nil))))

(defn nippy-seq-stash
  ([seq]
     (nippy-seq-stash seq (temp-filename)))
  ([seq filename]
     (with-open [stream (java.io.DataOutputStream. (clojure.java.io/output-stream filename))]
       (freeze-many-to-stream! seq stream))
     (SeqStash. filename #(thaw-many-from-stream! (java.io.DataInputStream. (clojure.java.io/input-stream %))))))

(defn delete [stash]
  (clojure.java.io/delete-file (.filename stash) true))

(defmacro with-stash [bindings & body]
  (assert (vector? bindings))
  (assert (even? (count bindings)))
  (if-let [[name seq & bindings] (seq bindings)]
    (do (assert (symbol? name) "with-stash only allows symbols in bindings")
        `(let [~name ~seq]
           (try
             (with-stash ~(vec bindings) ~@body)
             (finally
               (delete ~name)))))
    `(do ~@body)))
