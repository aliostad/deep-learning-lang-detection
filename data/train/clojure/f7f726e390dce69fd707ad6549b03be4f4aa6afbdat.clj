(ns poehub.dat
  (:import [com.google.common.io LittleEndianDataInputStream]
           [java.io FileInputStream RandomAccessFile File FileOutputStream]
           [java.nio ByteBuffer ByteOrder])
  (:require [clojure.tools.logging :as log]
            [clojure.data.json :as json]
            [poehub.config :as config]
            [clojure.java.io :as io]))

(def MAGIC (Long/parseUnsignedLong "13527612320720337851"))

(defn handle-spec-line [state line]
  (let [clean-line (.trim (.replaceAll line "[\\[\\]]" ""))]
    (condp re-seq line
      #"^\[" {:current-file clean-line
              :current-field nil
              :data (assoc (:data state) clean-line [])}
      #"^ +\[\[\[" (assoc state :current-field clean-line)

      #"^ +type = " (update-in state [:data (:current-file state)]
                               (fn [fields]
                                 (concat fields [{:type (aget (.split clean-line " ") 2)
                                                  :field (:current-field state)}])))
      state)))

(defn parse-specification [filename]
  (with-open [rdr (io/reader (io/resource filename))]
    (let [filtered-lines (filter #(let [line (.trim %1)]
                                    (and (not (.startsWith line "#"))
                                         (not (= (.length line) 0))))
                                 (line-seq rdr))]
      (doall
       (:data (reduce handle-spec-line
                      {:current-file nil
                       :current-field nil
                       :data {}}
                      filtered-lines))))))

(def specs (parse-specification "dat.specification.ini"))

(defn read-bytes [stream num]
  (let [start (.getFilePointer stream)
        bytes (into-array Byte/TYPE (take num (repeatedly #(.readByte stream))))]
    (log/trace "pos:" start "bytes:" (seq bytes))
    bytes))

(defn bytes-to-uint-le [bytes]
  (+ (bit-shift-left (bit-and (aget bytes 3) 0xFF) 24)
     (bit-shift-left (bit-and (aget bytes 2) 0xFF) 16)
     (bit-shift-left (bit-and (aget bytes 1) 0xFF) 8)
     (bit-shift-left (bit-and (aget bytes 0) 0xFF) 0)))

(defn bytes-to-ulong-le [bytes]
  (+ (bit-shift-left (bit-and (aget bytes 7) 0xFF) 56)
     (bit-shift-left (bit-and (aget bytes 6) 0xFF) 48)
     (bit-shift-left (bit-and (aget bytes 5) 0xFF) 40)
     (bit-shift-left (bit-and (aget bytes 4) 0xFF) 32)
     (bit-shift-left (bit-and (aget bytes 3) 0xFF) 24)
     (bit-shift-left (bit-and (aget bytes 2) 0xFF) 16)
     (bit-shift-left (bit-and (aget bytes 1) 0xFF) 8)
     (bit-shift-left (bit-and (aget bytes 0) 0xFF) 0)))

(defn bytes-to-int-le [bytes]
  (unchecked-int (bytes-to-uint-le bytes)))

(defn bytes-to-long-le [bytes]
  (unchecked-long (bytes-to-ulong-le bytes)))

(defn read-int [stream]
  (-> (read-bytes stream 4)
      (bytes-to-int-le)))

(defn read-uint [stream]
  (-> (read-bytes stream 4)
      (bytes-to-uint-le)))

(defn read-long [stream]
  (-> (read-bytes stream 8)
      (bytes-to-long-le)))

(defn read-ulong [stream]
  (-> (read-bytes stream 8)
      (bytes-to-ulong-le)))

(defn find-magic [stream record-count]
  (log/debug "Record count:" record-count)
  (loop [i 0]
    (if (= (read-long stream) MAGIC)
      (do
        (log/debug "Found magic at:" (- (.getFilePointer stream) 8))
        {:data-section-offset (- (.getFilePointer stream) 8)
         :record-length i})
      (do
        (.seek stream (+ (.getFilePointer stream) (+ -8 record-count)))
        (recur (inc i))))))


(defn read-utf16-string [stream]
  (loop [b1 (.readByte stream)
         b2 (.readByte stream)
         buffer []]
    (if (and (= b1 0) (= b2 0))
      (String. (into-array Byte/TYPE buffer) "UTF-16LE")
      (recur (.readByte stream)
             (.readByte stream)
             (conj buffer b1 b2)))))

(defn read-type [stream type data-section-offset]
  (log/trace "pos:" (.getFilePointer stream) "read-type:" type)
  (condp re-find type
    #"ref\|list" (do
                   (log/trace "pos: " (.getFilePointer stream))
                   (let [num (read-int stream)
                         pointer (read-int stream)
                         pos (.getFilePointer stream)
                         sub-type (aget (.split type "\\|") 2)]
                     (log/trace "num:" num "pointer:" pointer  "pos:" pos)
                     (.seek stream (+ data-section-offset pointer))
                     (log/trace "tell: " (.getFilePointer stream))
                     (let [result (doall (for [i (range num)]
                                           (read-type stream sub-type data-section-offset)))]
                       (.seek stream pos)
                       (log/trace "result" result)
                       result)))
    #"ref\|.*"  (do
                  (log/trace "pos: " (.getFilePointer stream))
                  (let [pointer (read-int stream)
                        pos (.getFilePointer stream)
                        sub-type (second (.split type "\\|"))]
                    (log/trace "pointer:" pointer "pos:" pos)
                    (try
                      (.seek stream (+ data-section-offset pointer))
                      (let [result (read-type stream sub-type data-section-offset)]
                        (.seek stream pos)
                        result)
                      (catch Exception e
                        (log/error e "Failed to read reference")
                        "ERROR"))))
    #"ulong" (read-ulong stream)
    #"uint" (read-uint stream)
    #"long" (read-long stream)
    #"int" (read-int stream)
    #"u?byte" (.readByte stream)
    #"bool" (.readByte stream)
    #"string" (read-utf16-string stream))) ; FIXME

(defn read-record [stream data-section-offset spec]
  (log/trace "hmm" spec)
  (log/trace "offset" data-section-offset)
  (into {}
        (map (fn [{:keys [type field]}]
               (log/trace "reading:" type field)
               [field (read-type stream type data-section-offset)])
             spec)))

(def data-version (atom nil))

(defn set-data-version! [v]
  (log/info "using data version:" v)
  (reset! data-version v))

(defn- get-latest-data-version []
  (.getName
   (reduce (fn [f1 f2]
             (if (> (.lastModified f1) (.lastModified f2))
               f1
               f2))
           (seq (.listFiles (File. config/data-dir))))))

(defn get-data-version []
  (if (not @data-version)
    (set-data-version! (get-latest-data-version)))
  @data-version)

(defn- resolve-filename [filename]
  (if (.isAbsolute (File. filename))
    filename
    (str config/data-dir File/separator (get-data-version) File/separator filename)))

(defn parse [filename]
  (lazy-seq
   (let [resolved-filename (resolve-filename filename)
         file (File. resolved-filename)
         size (.length file)
         stream (RandomAccessFile. file "r")
         record-count (read-int stream)
         magic (find-magic stream record-count)
         spec (get specs (.getName file))]
     (if (not spec)
       (throw (IllegalArgumentException. (str "No spec found for: " (.getName file)))))
     (log/debug "records:" record-count)
     (log/debug "magic: " magic)
     (log/debug "spec:" spec)
     (for [i (range record-count)]
       (do (.seek stream (+ (* (:record-length magic) i) 4))
           (log/trace "seeked " (.getFilePointer stream))
           (assoc (read-record stream (:data-section-offset magic) spec)
                  "Row"
                  i))))))

(def parse-memoized (memoize parse))

(defn jsonify-all []
  (log/info "writing json files...")
  (let [dir (File. (str config/data-dir File/separator (get-data-version)))]
    (doseq [dat (seq (.listFiles dir))]
      (let [parsed (parse-memoized (.getName dat))
            out-file (File. (str config/data-dir File/separator (get-data-version) File/separator (.replaceAll (.getName dat) "\\.dat$" ".json")))]
        (if (not (.exists out-file))
          (let [stream (FileOutputStream. out-file)]
            (log/info "writing json file:" (.getName out-file))
            (try
              (.write stream (.getBytes (json/write-str parsed) "UTF-8"))
              (.close stream)
              (catch Exception e
                (.close stream)
                (.delete out-file)
                (log/error e "failed to write/parse json")))))))))

