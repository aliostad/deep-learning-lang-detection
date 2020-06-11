(ns apoya.util.classloader
  (:require [apoya.resources.fs :as fs]
            [org.jclouds.blobstore2 :as bs]
            [clojure.java.io :as io])
  (:gen-class
    :name apoya.classloader.JCloudsClassLoader
    :extends java.lang.ClassLoader
    :exposes-methods {defineClass exposeDefineClass}
    :main false))

(defn -findClass [this name]
  (let [full-path (str (.replace name \. \/) ".class")
        input-stream (and (bs/blob-exists? fs/sites-base "classpath" full-path)
                          (bs/get-blob-stream fs/sites-base "classpath" full-path))]
    (if input-stream
      (let [output-stream (java.io.ByteArrayOutputStream.)]
        (io/copy input-stream output-stream)
        (.exposeDefineClass this (.toByteArray output-stream) 0 (.size output-stream)))
      (throw (ClassNotFoundException. name)))))

(defn -findResource [this name]
  (java.net.URL. (str "jclouds:" name)))

(defmacro with-classloader  [cl & body]
  `(binding  [*use-context-classloader* true]
     (let  [cl# (.getContextClassLoader  (Thread/currentThread))]
       (try  (.setContextClassLoader  (Thread/currentThread) ~cl)
         ~@body
         (finally
           (.setContextClassLoader  (Thread/currentThread) cl#))))))

