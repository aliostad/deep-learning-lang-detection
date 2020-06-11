(ns bill.tasks.jar
  (:use bill.task)
  (:require [bill.build :as build]
            [clojure.java.io :as java-io]
            [clojure.string :as string])
  (:import [java.io ByteArrayInputStream File]
           [java.util.jar Manifest JarEntry JarOutputStream]))

(defn default-manifest []
  { "Manifest-Version" "1.0"
    "Created-By" (str "Bill " (or (build/bill-version) (System/getProperty "bill.version")))
    "Built-By" (System/getProperty "user.name")
    "Build-Jdk" (System/getProperty "java.version") })

(defn manifest-map []
  (merge (default-manifest) (build/manifest)))

(defn- manifest-entry [[manifest-key manifest-value]]
  (cond
    (symbol? manifest-value) (manifest-entry [manifest-key (resolve manifest-value)])
    (fn? manifest-value) (manifest-entry [manifest-key (manifest-value)])
    :else (str (name manifest-key) ": " manifest-value)))

(defn manifest-string []
  (string/join "\n" (map manifest-entry (manifest-map))))

(defn manifest-bytes []
  (.getBytes (manifest-string) "UTF-8"))

(defn manifest-input-stream []
  (ByteArrayInputStream. (manifest-bytes)))

(defn manifest []
  (Manifest. (manifest-input-stream)))

(defn create-jar-output-stream [jar-file]
  (JarOutputStream. (java-io/output-stream jar-file) (manifest)))

(defmulti add-to-jar (fn [_ _ data] (type data)))

(defmethod add-to-jar File [^JarOutputStream jar-output-stream ^String path ^File file]
  (.putNextEntry jar-output-stream
    (doto (JarEntry. path)
      (.setTime (.lastModified file))))
  (java-io/copy file jar-output-stream))

(defmethod add-to-jar String [^JarOutputStream jar-output-stream ^String path ^String string]
  (.putNextEntry jar-output-stream (JarEntry. path))
  (java-io/copy (.getBytes string) jar-output-stream))

(defn create-jar-path [^File root-dir ^File file-to-add]
  (when (and root-dir file-to-add)
    (.substring (.getAbsolutePath file-to-add) (count (.getAbsolutePath root-dir)))))

(defn file? [^File file-to-add]
  (not (.isDirectory file-to-add)))

(defn add-dir-to-jar
  ([^JarOutputStream jar-output-stream ^File dir] (add-dir-to-jar jar-output-stream dir file?))
  ([^JarOutputStream jar-output-stream ^File dir filter]
    (doseq [file-to-add (flatten (file-seq dir))]
      (when (filter file-to-add)
        (add-to-jar jar-output-stream (create-jar-path dir file-to-add) file-to-add)))))

(defn has-extension? [^File file ^String extension]
  (and (file? file) (.endsWith (.getPath file) (str "." extension))))

(defn has-any-extension? [^File file extensions]
  (some #(has-extension? file %) extensions))
  
(defn has-source-extension? [^File file]
  (if-let [source-extensions (seq (build/source-extensions))]
    (has-any-extension? file source-extensions)
    true))

(defn has-compiled-extension? [^File file]
  (if-let [compiled-extensions (seq (build/compiled-extensions))]
    (has-any-extension? file compiled-extensions)
    true))

(defn add-source-files [^JarOutputStream jar-output-stream]
  (doseq [source-path (build/source-path-files)]
    (add-dir-to-jar jar-output-stream source-path has-source-extension?))
  jar-output-stream) 

(defn add-resource-files [^JarOutputStream jar-output-stream]
  (doseq [resource-path (build/resource-path-files)]
    (add-dir-to-jar jar-output-stream resource-path))
  jar-output-stream)
  
(defn add-compiled-files [^JarOutputStream jar-output-stream]
  (add-dir-to-jar jar-output-stream (build/compile-path-file) has-compiled-extension?)
  jar-output-stream)

(defn add-build-clj-file [^JarOutputStream jar-output-stream]
  (add-dir-to-jar jar-output-stream (build/build-file))
  jar-output-stream)
  
(defn add-files-to-jar [^JarOutputStream jar-output-stream]
  (add-compiled-files (add-resource-files (add-source-files jar-output-stream))))

(defn write-jar [jar-file]
  (when jar-file
    (when-let [jar-directory (.getParentFile jar-file)]
      (.mkdirs jar-directory)))
  (with-open [jar-output-stream (create-jar-output-stream jar-file)]
    (add-files-to-jar jar-output-stream))
  (println "Wrote:" (.getAbsolutePath jar-file)))

(deftask jar
  "Package up all the project's files into a jar file."
  [& args]
  (run-task :compile [])
  (if-let [jar-file (build/target-jar-file)]
    (write-jar jar-file)
    (println "No jar file set.")))