(ns net.swiftkey.keysync-crate.group
  "Functions to manage keys store in the keysync blob.

   You can rebind *keysync-groups-container* if you want to use a custom
   bucket for storing user public keys."
  (:require [clojure.edn :as edn]
            [clojure.set :as set]
            [clojure.string :as str]
            [clojure.java.io :as io]
            [org.jclouds.blobstore2 :as blob])
  (:import  [java.io PushbackReader]))

(defmacro ^:private with-keysync-container
  [blobstore container & body]
  `(do
     (when-not (blob/container-exists? ~blobstore ~container)
       (blob/create-container ~blobstore ~container
                              :public-read? false))
     ~@body))

(defmacro ^:private with-check-group-not-exists
  [blobstore container group & body]
  `(if (blob/blob-exists? ~blobstore ~container ~group)
     (throw (Exception. (str "Attempt to overwrite existing group: " ~group)))
     (do ~@body)))

(defmacro ^:private with-check-group-exists
  [blobstore container group & body]
  `(if-not (blob/blob-exists? ~blobstore ~container ~group)
     (throw (Exception. (str "Attempt to use missing group: " ~group)))
     (do ~@body)))

(defn- edn->blob
  "Create a blob for some Clojure data."
  [name val]
  (blob/blob name
             :payload (prn-str val)
             :content-type "application/edn"))

(defn- read-edn
  "Restore Clojure data from blobstore."
  [blobstore container path]
  (when (blob/blob-exists? blobstore container path)
    (edn/read
     (PushbackReader.
      (io/reader
       (blob/get-blob-stream blobstore container path))))))

(defn- swap-edn!
  "A swap-like function for values in the blobstore."
  [blobstore container key update-fn]
  (->> (read-edn blobstore container key)
       (update-fn)
       (edn->blob key)
       (blob/put-blob blobstore container)))

(defn add-group!
  "Add a group to the blobstore."
  [blobstore container group]
  (with-keysync-container blobstore container
    (with-check-group-not-exists blobstore container group
      (swap-edn! blobstore container group (constantly {})))))

(defn remove-group!
  "Remove a group from the blobstore."
  [blobstore container group]
  (with-keysync-container blobstore container
    (with-check-group-exists blobstore container group
      ;; For reasons I don't understand, this doesn't actually delete the
      ;; key, but replaces it with an empty value.
      (blob/remove-blob      blobstore container group)
      (blob/delete-directory blobstore container group))))

(defn add-user!
  "Add a user's public key to the given group."
  [blobstore container group user public-key]
  (with-keysync-container blobstore container
    (with-check-group-exists blobstore container group
      (swap-edn! blobstore container group (fn [g] (assoc g user public-key))))))

(defn remove-user!
  "Remove the given user's public key from this group."
  [blobstore container group user]
  (with-keysync-container blobstore container
    (with-check-group-exists blobstore container group
      (swap-edn! blobstore container group (fn [g] (dissoc g user))))))

(defn list-groups
  "Return a set of the group names in this blobstore."
  [blobstore container]
  (with-keysync-container blobstore container
    (into #{} (map blob/blob-name
                   (blob/blobs blobstore container)))))

(defn list-users
  "Return the set of user names in this group."
  [blobstore container group]
  (with-keysync-container blobstore container
    (with-check-group-exists blobstore container group
      (into #{} (keys (read-edn blobstore container group))))))

(defn- format-keys
  [& public-keys]
  (str/join "\n" (map str/trim-newline public-keys)))

(defn- get-keys
  [blobstore container group]
  (with-check-group-exists blobstore container group
    (vals (read-edn blobstore container group))))

(defn authorized-keys
  "Return a string containing the content for an OpenSSH
   authorized_keys file, authorizing users of the requested
   groups."
  [blobstore container & groups]
  (with-keysync-container blobstore container
   (apply format-keys
          (into #{} (mapcat (partial get-keys blobstore container) groups)))))

(defn revoke-all!
  "Revoke access to all groups for these users.

   NOTE - This just updates the state of the blobstore, so you'll
          need to run the appropriate phase on any deployed nodes
          for this to take effect!"
  [blobstore container & users]
  (with-keysync-container blobstore container
    (doseq [g (list-groups blobstore container)]
      (swap-edn! blobstore container g
                 (fn [user-group]
                   (select-keys user-group
                                (set/difference (set (keys user-group))
                                                (set users))))))))
