(ns poehub.ggpk
  (:import [java.io RandomAccessFile FileInputStream FileOutputStream]
           [java.text SimpleDateFormat]
           [java.util TimeZone]
           [java.io File]
           [org.apache.commons.codec.digest DigestUtils])
  (:require [clojure.tools.logging :as log]
            [clojure.tools.logging :as log]
            [poehub.dat :as dat]))

(defn read-header [stream]
  ;; Version U32 | Identifier 'GGPK' | Unknown U32 | Root offset U64 | Unknown U64
  {:version (dat/read-int stream)
   :identifier (String. (dat/read-bytes stream 4) "ASCII")
   :unknown1 (dat/read-int stream)
   :root (dat/read-long stream)})

(declare read-entry)

(defn read-entry-file [stream path acc next-pos]
  (let [name-length (dat/read-int stream)]
    (.seek stream (+ (.getFilePointer stream) 0x20))
    (let [name (.trim (String. (dat/read-bytes stream (* name-length 2)) "UTF-16LE"))
          offs (.getFilePointer stream)
          full-name (clojure.string/join "/" (filter #(not (.equals %1 "")) (concat path [name])))]
      (log/trace "file name:" name)
      (conj acc 
            {:name full-name
             :offset offs
             :size (- next-pos offs)}))))

(defn read-entry-directory [stream path acc]
  (let [name-length (dat/read-int stream)
        child-count (dat/read-int stream)]
    (.seek stream (+ (.getFilePointer stream) 0x20))
    (let [name (.trim (String. (dat/read-bytes stream (* name-length 2)) "UTF-16LE"))]
      (log/trace "directory name:" name)
      (log/trace "name length:" name-length "children:" child-count)
      (loop [i 0
             m acc]
        (do (dat/read-int stream)
            (let [childoffs (dat/read-long stream)
                  nextpos (.getFilePointer stream)]
              (.seek stream childoffs)
              (log/trace "childoffs:" childoffs)
              (let [result (read-entry stream (concat path [name]) m)]
                (.seek stream nextpos)
                (if (= i (- child-count 1))
                  result
                  (recur (+ i 1) result)))))))))

(defn read-entry [stream path acc]
  (log/trace "reading entry:" path)
  (let [curr (.getFilePointer stream)
        next-offset (dat/read-int stream)
        entry-type (String. (dat/read-bytes stream 4) "ASCII")]
    (log/trace "entry-type:" entry-type)
    (condp = entry-type
      "PDIR" (read-entry-directory stream path acc)
      "FILE" (read-entry-file stream path acc (+ curr next-offset)))))


(defn read-entries [filename]
  (with-open [stream (RandomAccessFile. filename "r")]
    (.seek stream 0)
    (let [header (read-header stream)]
      (log/trace "found header: " header)
      (.seek stream (:root header))
      (read-entry stream [] []))))

(defn read-file [filename spec]
  (with-open [stream (RandomAccessFile. filename "r")]
    (.seek stream (:offset spec))
    (dat/read-bytes stream (:size spec))))

(defn get-hash [fn]
  (with-open [stream (FileInputStream. fn)]
    (DigestUtils/md5Hex stream)))

(defn get-version [input-file]
  (let [formatter (doto (SimpleDateFormat. "yyyyMMdd'T'HHmmss'Z'")
                    (.setTimeZone (TimeZone/getTimeZone "UTC")))
        timestamp (.format formatter (.lastModified (File. input-file)))
        hash (get-hash input-file)]
    (str timestamp "-" hash)))

(defn get-final-path [base version]
  (str base (File/separator) version))

(defn extract-data-files [input-file base-output-dir]
  (log/info "extracting from:" input-file "...")
  (let [version (get-version input-file)
        output-dir-name (get-final-path base-output-dir version)
        output-dir (File. output-dir-name)]
    (log/info "output directory:" output-dir-name)
    (if (not (.exists output-dir))
      (do
        (.mkdirs output-dir)
        (log/info "reading entries...")
        (let [entries (read-entries input-file)
              data-entries (filter #(and (> (.indexOf (:name %1) ".dat") -1)
                                         (= (.indexOf (:name %1) "Portuguese") -1)
                                         (= (.indexOf (:name %1) "ShaderCache.dat") -1))
                                   entries)]
          (log/info "extracting data files..")
          (doseq [de data-entries]
            (let [data (read-file input-file de)
                  of (FileOutputStream. (str output-dir-name
                                             (File/separator)
                                             (.replaceAll (:name de) "Data/" "")))]
              (.write of data)
              (.close of)))))
      (log/info "already exists, nothing to do"))
    (log/info "extraction done")
    version))
