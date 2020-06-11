(ns capra.package
  "Retrieve and manage packages on a Capra server."
  (:refer-clojure :exclude [get load])
  (:require capra.account)
  (:use capra.http-client)
  (:use capra.io-utils)
  (:use capra.system)
  (:use capra.util)
  (:import java.io.File)
  (:import java.io.FileInputStream))

(defn get
  "Retrieve package metadata by account, name and version."
  ([path]
    (http-get (str *source* "/" path)))
  ([account name version]
    (get (str account "/" name "/" version))))

(defn upload-file
  "Upload a file to an existing package."
  [account package version filepath]
  (let [url  (str *source* "/" account "/" package "/" version)
        pass (capra.account/get-key account)]
    (doto (http-connect "POST" url)
      (basic-auth account pass)
      (content-type "application/java-archive")
      (send-stream (FileInputStream. filepath)))))

(defn create
  "Upload a new package with files."
  [package]
  (let [account (package :account)
        passkey (capra.account/get-key account)]
    (do (doto (http-connect "POST" (str *source* "/" account))
          (basic-auth account passkey)
          (send-data (dissoc package :files)))
        (doseq [file (package :files)]
          (upload-file account
                       (package :name)
                       (package :version)
                       file)))))

(def index-file
  (File. *capra-home* "cache.index"))

(def cache
  (atom (or (read-file index-file) {})))

(defn cached?
  "Is a package cached?"
  [account name version]
  (contains? @cache [account name version]))

(defn- cache-path
  "Return the download path for a file."
  [file-info]
  (File. (File. *capra-home* "cache")
         (str (file-info :sha1) ".jar")))

(defn- download-file
  "Download a package file."
  [file-info dest-path]
  (let [temp-file (File/createTempFile "capra" ".jar")]
    (http-copy (file-info :href) temp-file)
    (if-not (= (file-info :sha1) (file-sha1 temp-file))
      (throwf "Remote SHA1 does not match downloaded file")
      (.renameTo temp-file dest-path))))

(defn cache!
  "Downloads and caches the content of a package."
  [package]
  (doseq [file-info (package :files)]
    (let [filepath (cache-path file-info)]
      (when-not (.exists filepath)
        (download-file file-info filepath))))
  (let [key [(package :account)
             (package :name)
             (package :version)]]
    (swap! cache assoc key package)
    (write-file index-file @cache)))

(def loaded (atom #{}))

(defn load
  "Load a cached package into the classpath."
  [package]
  (when-not (@loaded package)
    (swap! loaded conj package)
    (doseq [file-info (package :files)]
      (add-classpath (.toURL (cache-path file-info))))))

(defn install
  "Downloads the package and all dependencies, then adds them to the
  classpath."
  [account name version]
  (let [package (or (@cache [account name version])
                    (get account name version))]
    (doseq [dependency (package :depends)]
      (apply install dependency))
    (cache! package)
    (load package)))
