(ns naclj.key-store
	(:require 
	  [naclj.key-protocol :as kp]
	  [naclj.uri-util :as uri]
  ))

(defprotocol INaclKeyStore
  "Interface to manage storing and finding private, public and other keys by kid."
  (add-key [this key][this kid key])
  (get-key [this kid]))

(defmulti make-key-store
  (fn [provider & xs] [provider]))

;;

(defrecord TDefaultKeyStore [key-store])

(defmethod make-key-store :default
  [provider]
  (map->TDefaultKeyStore {:key-store (atom {})}))

(extend-type TDefaultKeyStore
  INaclKeyStore
    (add-key 
      ([this key] (add-key this (uri/uri key) key))
      ([this kid key]
        (swap! (:key-store this) assoc-in [kid] key)))
    (get-key [this kid]
      (get-in @(:key-store this) [kid])))


