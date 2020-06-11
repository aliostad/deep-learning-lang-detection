(ns zambuko-back.classloader
  (:require [org.jclouds.blobstore2 :as bs]
            [zambuko-back.config :as zc]
            [clojure.java.io :as io])
  (:gen-class
    :name zambuko.classloader.JCloudsClassLoader
    :extends java.lang.ClassLoader
    :exposes-methods {defineClass exposeDefineClass}
    :main false))

(defn -findClass [this name]
  (let [full-path (str (.replace name \. \/) ".class")
        input-stream (and (bs/blob-exists? @zc/bstore "classpath" full-path)
                    (bs/get-blob-stream @zc/bstore "classpath" full-path))]
    (if input-stream
      (let [output-stream (java.io.ByteArrayOutputStream.)]
        (io/copy input-stream output-stream)
        (.exposeDefineClass this (.toByteArray output-stream) 0 (.size output-stream)))
      (throw (ClassNotFoundException. name)))))

(defn -findResource [this name]
  (java.net.URL. (str "zambuko:" name)))

