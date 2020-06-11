;;;; Utilities needed for enhancing classes and debugging
(ns profiler-util
  (:use [enhance-class]
        [class-util])
  (:import
   [java.nio.channels FileChannel]
   [java.nio ByteBuffer]
   [java.io File])
  (:require [clojure.java.io :as io]))

(def curr-pos (atom 0))

(defn- increment-position [incrementBy]
  (swap! curr-pos (fn[n] (+ incrementBy n))))

(defn- reset-position []
  (reset! curr-pos 0))

(defn- accumulate-classes [fileLocation accumulator]
  (let [currFile (io/file fileLocation)]
    (do 
      (if (.isDirectory currFile)
        (concat accumulator (mapcat (fn[fileLocation] (accumulate-classes fileLocation '())) (.listFiles currFile)))
        (let [fileName (.getName currFile)]
          (if
              (or (.endsWith fileName ".class") (.endsWith fileName ".jar"))
            (conj accumulator currFile)
            accumulator))))))



(defn find-classes [fileLocations]
  (mapcat (fn[fileLocation] (accumulate-classes fileLocation '())) fileLocations))

(defn- instrument-class-stream [fileStream indexWriter classFileWriter]
  (let [instrumentedClass (instrument-class fileStream)
        instrumentedBytes (:bytes instrumentedClass)
        bytesLength (alength instrumentedBytes)
        clazzName (:name instrumentedClass)]
    (.write indexWriter (str  clazzName " " @curr-pos " " (increment-position bytesLength) "\n"))
    (.write classFileWriter instrumentedBytes)
    (.flush classFileWriter)
    clazzName))

(defn- entries [jarFile]
  (enumeration-seq (.entries jarFile)))

(defn- instrument-jar [file indexWriter classFileWriter]
  (with-open [jarFile (java.util.jar.JarFile. file)]
    (doseq [jarEntry (enumeration-seq (.entries jarFile))]
      (if (.endsWith (.getName jarEntry) ".class")
        (with-open [jarStream (.getInputStream jarFile jarEntry)]
          (instrument-class-stream jarStream indexWriter classFileWriter))))))

(defn extract-first-string[file-name] 
  (let [lines (.split (slurp file-name) "\n")]
    (map (fn[line] (first (.split line " "))) lines)))

(defn create-regex [file]
  (let [names (extract-first-string file)]
    (str 
     (if (> (count names) 1)
       (extract-common-prefix  names "/")
       "")
   ".*")))

(defn instrument-classes [files]
  (let [indexFile (File/createTempFile "index" "blob")
        classFile (File/createTempFile "clasdef" "blob")]
    (do 
      (reset-position)
      (with-open [indexWriter (io/writer indexFile)
                  classFileWriter (io/output-stream classFile)]
        (doseq [file files] 
          (if (.endsWith (.getName file) ".class")
            (with-open [origClassFileStream (io/input-stream file)]
              (instrument-class-stream origClassFileStream indexWriter classFileWriter))
            (instrument-jar file indexWriter classFileWriter))))
      (.deleteOnExit indexFile)
      (.deleteOnExit classFile)
      {:indexFile (.getAbsolutePath indexFile)
       :classFile (.getAbsolutePath classFile)
       :regex (create-regex indexFile)
       })))

(comment
  (find-classes (conj '() (str (System/getProperty "user.dir") "/profiler/agent/target/")))
  (profile-vm "32477" "org/eclipse/jetty/server/.*" "/home/apurba/.m2/repository/org/eclipse/jetty/jetty-server/7.6.8.v20121106/jetty-server-7.6.8.v20121106.jar"))

