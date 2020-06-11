(ns carapace.shell
  "Execute processes from clojure"
  (:require
   [carapace.proc :as proc]
   [carapace.stream :as stream]
   [com.palletops.api-builder.api :refer [defn-api]]
   [schema.core :as schema :refer [either optional-key]]))

(defonce default-streamer
  (delay
   (let [s (stream/streamer {})]
     (stream/start s)
     s)))

(defn- stream-copy-maps
  "Given a process p, and a possibly nil input stream or reader,
  return a sequence of stream-maps to copy the input stream to the process,
  and the output and error streams to *out* and *err*."
  [p {:keys [in redirect-error-stream buffer-size buffer] :as options}]
  (filter
   identity
   [(if in
      (stream/stream-copy in (:in p) {})
      (.close (:in p)))
    (stream/stream-copy
     (:out p) *out*
     (select-keys options [:buffer-size :buffer :flush]))
    (when-not redirect-error-stream
      (stream/stream-copy (:err p) *err* {:flush flush}))]))

(def ShOptions
  {(optional-key :in) (either java.io.InputStream java.io.Reader)
   (optional-key :streamer) stream/Streamer
   (optional-key :buffer-size) schema/Int
   (optional-key :buffer) bytes
   (optional-key :redirect-error-stream) schema/Bool
   (optional-key :clear) schema/Bool
   (optional-key :env) {(either String clojure.lang.Named) String}
   (optional-key :directory) String
   (optional-key :flush) schema/Bool
   (optional-key :stream-maps-f) schema/Any})

(defn-api sh
  "Execute a process, returning the exit code.
  The process executes `command`, a sequence of strings.
  Output goes to *out*."
  {:sig [[[String] ShOptions :- schema/Int]]}
  [command {:keys [in env clear
                   streamer buffer-size buffer
                   redirect-error-stream
                   flush
                   stream-maps-f]
            :as options
            :or {stream-maps-f stream-copy-maps}}]
  (let [s (or streamer @default-streamer)
        options (merge {:flush true :redirect-error-stream true} options)
        p (proc/proc command
                     (select-keys
                      options
                      [:env :clear :directory :redirect-error-stream]))
        stream-maps (stream-maps-f p options)]
    (doseq [sm stream-maps]
      (stream/stream s sm))
    (let [e (proc/wait-for p)]
      (doseq [sm stream-maps]
        (stream/un-stream s sm))
      e)))

(defn stream-string-maps
  "Return a map with a function and string buffers.  The function,
  given a process p, and a possibly nil input stream or reader, will
  return a sequence of stream-maps to copy the input stream to the
  process, and the output streams to string buffers."
  []
  (let [out-b (java.io.StringWriter.)
        err-b (java.io.StringWriter.)]
    {:f (fn [p
             {:keys [in redirect-error-stream buffer-size buffer] :as options}]
          (filter
           identity
           [(if in
              (stream/stream-copy in (:in p) {})
              (.close (:in p)))
            (stream/stream-copy
             (:out p) out-b
             (select-keys options [:buffer-size :buffer :flush]))
            (when-not redirect-error-stream
              (stream/stream-copy (:err p) err-b {:flush flush}))]))
     :out out-b
     :err err-b}))

(def ShMapOptions
  (dissoc ShOptions (optional-key :stream-maps-f)))

(def ShMap
  {:exit schema/Int
   :out String
   :err String})

(defn-api sh-map
  "Execute a process, returning a map with the exit code, the stdout
  and the stderr.  The process executes `command`, a sequence of
  strings."
  {:sig [[[String] ShMapOptions :- ShMap]]}
  [command {:keys [in env clear
                   streamer buffer-size buffer
                   redirect-error-stream
                   flush]
            :as options}]
  (let [{:keys [f out err]} (stream-string-maps)
        e (sh command (assoc options :stream-maps-f f))]
    {:exit e
     :out (.toString out)
     :err (.toString err)}))
