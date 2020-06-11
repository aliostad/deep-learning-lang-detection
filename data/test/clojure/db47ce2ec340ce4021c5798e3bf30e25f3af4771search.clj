;; This search.clj file should do the following:
;;
;; x Contain a list of all of the main keyservers
;; x Search and return the keyring for the users for the query
;; x Leave parsing of the keyring for keyring.clj (currently does not)
;; - Manage searches with multiple returned keys/ids
;; - Find more keyservers to add
;; - SSL/TLS Support
;; - Implement a server chooser



(ns crypto-castle.pgp.search
  (:import 
    (java.net URL)
    (java.net URLEncoder)
    (java.io ByteArrayInputStream)
    (org.bouncycastle.openpgp PGPUtil
                              PGPObjectFactory))
  (:use [net.cgrand.enlive-html])
  (:require [crypto-castle.pgp.key :as pgpkey]))


(def keyservers ["http://pgp.mit.edu:11371/"
                 "http://pool.sks-keyservers.net:11371/"
                 "http://zimmermann.mayfirst.org/"])

(def keyserver-key-url "http://pgp.mit.edu:11371/pks/lookup?")

(defn build-search-url
  "Returns a url (as a string) encoded with the search parameters"
  [base-url params]
  (str base-url
       "search="
       (URLEncoder/encode params "UTF-8")))


(defn retrieve-key
  "Returns a string of pgp key data from search"
  [search-term]
  ;; Should url format the string and append to search
  (-> 
    (str (build-search-url keyserver-key-url search-term) "&op=get&exact=on")
    URL. 
    html-resource 
    (select [:body :pre])
    first
    (get :content)
    first))


(defn parse-to-keyring
  [key-string]
  (.nextObject
    (new PGPObjectFactory
         (PGPUtil/getDecoderStream
           (new ByteArrayInputStream
                (.getBytes key-string))))))


(defn find-pubring
  "Returns a PGPPublicKeyRing based on keysearch"
  [search-term]
  (parse-to-keyring
    (retrieve-key search-term)))
