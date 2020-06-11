(ns carapace.stream
  "Stream processing for Process input and output streams.
  Provides an abstraction to pump stream data as defined by a stream-map."
  (:require
   [clojure.core.async :refer [<! alts! chan go-loop put! timeout]]
   [com.palletops.api-builder.api :refer [defn-api]]
   [schema.core :as schema :refer [either optional-key validate]]))

(def StreamerOptions
  {(optional-key :period) schema/Int})

(def Streamer
  {:streams clojure.lang.Atom
   :channel (schema/protocol clojure.core.async.impl.protocols/ReadPort)
   :period schema/Int})

(def StreamMap
  {:in (either java.io.InputStream java.io.Reader)
   :buffer schema/Any
   :buffer-size schema/Int
   :f schema/Any})

;;; # Streamer
(defn-api streamer
  "Return a streamer, that copies input streams to output streams.
  Use `start` to start the streamer.
  Will poll every `:period` milliseconds."
  {:sig [[StreamerOptions :- Streamer]]}
  [{:keys [period] :or {period 100}}]
  {:streams (atom [])
   :channel (chan)
   :period period})


;;; ## Polling

(defmulti poll
  (fn [{:keys [in]}]
    (type in)))

(defmethod poll java.io.InputStream
  [{:keys [in f buffer buffer-size]}]
  (when (pos? (.available in))
    (let [num-read (.read in buffer 0 buffer-size)]
      (f buffer num-read)
      true)))

(defmethod poll java.io.Reader
  [{:keys [in f buffer buffer-size flush]}]
  (when (.ready in)
    (let [num-read (.read in buffer 0 buffer-size)]
      (f buffer num-read)
      true)))


;;; ## Controlling the streamer

(defn-api start
  "Start streaming."
  {:sig [[Streamer :- clojure.core.async.impl.protocols.ReadPort]]}
  [{:keys [channel period streams] :as streamer}]
  (go-loop []
    (if (reduce
         (fn [x stream-map]
           (or
            (try (poll stream-map)
                 (catch Exception e
                   (.printStackTrace e)))
            x))
         nil
         @streams)
      (recur)
      (let [v (alts! [channel (timeout period)])]
        (if-not (first v)
          (recur))))))

(defn-api stop
  "Stop streaming.  Returns true unless already stopped."
  {:sig [[Streamer :- schema/Bool]]}
  [{:keys [channel] :as streamer}]
  (put! channel :done))

(defn-api stream
  "Stream the stream-map. Return the stream-map."
  {:sig [[Streamer StreamMap :- StreamMap]]}
  [{:keys [buffer-size streams] :as streamer} stream-map]
  (swap! streams conj stream-map)
  stream-map)

(defn-api un-stream
  "Stop streaming a stream-map."
  {:sig [[Streamer StreamMap :- Streamer]]}
  [{:keys [streams] :as streamer} stream-map]
  (poll stream-map)
  (swap! streams (fn [s] (remove #(= stream-map %) s)))
  streamer)


;;; # Stream copying

;;; Provides a stream map that will copy one stream to another

(defmulti copy-stream
  (fn copy-stream [out options buffer n]
    (type out)))

(defmethod copy-stream java.io.OutputStream
  [out {:keys [flush]} buffer n]
  (.write out buffer 0 n)
  (when flush
    (.flush out)))

(defmethod copy-stream java.io.Writer
  [out {:keys [flush]} buffer n]
  (.write out buffer 0 n)
  (when flush
    (.flush out)))

(defmulti stream-copy-map
  "Return a stream map for the given inputs"
  (fn stream-copy-map [in out {:keys [buffer buffer-size encoding flush]}]
    [(type in) (type out)]))

(defmethod stream-copy-map [java.io.InputStream java.io.OutputStream]
  [in out {:keys [buffer buffer-size encoding flush] :as options}]
  (let [buffer-size (or (and buffer (count buffer))
                        buffer-size
                        (* 16 1024))
        buffer (or buffer (byte-array buffer-size))]
    {:in in
     :buffer-size buffer-size
     :buffer buffer
     :f #(copy-stream out (select-keys options [:flush]) %1 %2)}))


(defmethod stream-copy-map [java.io.InputStream java.io.Writer]
  [in out {:keys [buffer buffer-size encoding flush] :as options}]
  (let [in (java.io.InputStreamReader. in encoding)
        buffer-size (or (and buffer (count buffer))
                        buffer-size
                        (* 16 1024))
        buffer (or buffer (char-array buffer-size))]
    {:in in
     :buffer-size buffer-size
     :buffer buffer
     :f #(copy-stream out (select-keys options [:flush]) %1 %2)}))

(defmethod stream-copy-map [java.io.Reader java.io.OutputStream]
  [in out {:keys [buffer buffer-size encoding flush] :as options}]
  (let [out (java.io.OutputStreamWriter. out encoding)
        buffer-size (or (and buffer (count buffer))
                        buffer-size
                        (* 16 1024))
        buffer (or buffer (char-array buffer-size))]
    {:in in
     :buffer-size buffer-size
     :buffer buffer
     :f #(copy-stream out (select-keys options [:flush]) %1 %2)}))

(def StreamCopyOptions
  {(optional-key :flush) schema/Bool
   (optional-key :buffer-size) schema/Int
   (optional-key :buffer) bytes
   (optional-key :encoding) String})

(defn-api stream-copy
  "Return a stream-map that will copy the input stream `in` to `out`
  using any specified options when passed to a streamer.  The input
  `in` may be an InputStream or a Reader. The output `out` may be an
  OutputStream or a Writer.

  The copy buffer is controlled by the `:buffer` and `:buffer-size`
  options.  If passed, the buffer is expected to be an array of the
  correct type for `in` and `out`.

  The `:flush` option controls whether the output stream is flushed
  after every write.

  The `:encoding` option takes a string and is used to specify the
  character encoding when wrapping or unwrapping a stream to/from a
  Reader or Writer."
  {:sig [[(either java.io.InputStream java.io.Reader)
          (either java.io.OutputStream java.io.Writer)
          StreamCopyOptions
          :- StreamMap]]}
  [in out {:keys [flush encoding buffer buffer-size]
           :or {flush true encoding "UTF-8"}
           :as options}]
  (stream-copy-map in out (merge {:flush true :encoding "UTF-8"} options)))
