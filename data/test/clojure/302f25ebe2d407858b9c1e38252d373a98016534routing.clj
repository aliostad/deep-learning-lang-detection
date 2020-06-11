(ns com.jimrthy.cluster-web.web.routing
  (:require [com.jimrthy.cluster-web.shared.util :as util]))


(defmulti dispatch
  (fn [message params]
    :Not-Implemented))

(defmethod dispatch :something [message params]
  (throw (Exception. "Not Imlemented")))

(defmethod dispatch :Error [message params]
  (throw (Exception. "FAIL")))

(defmethod dispatch :default [message params]
  ;; Really should return a 404.
  ;; FIXME: For development only.
  ;; For all intents and purposes, this almost definitely indicates
  ;; a piece of functionality that hasn't been ported yet.
  (util/log (str "Message: " message "\nParameters: " params))
  (throw (Exception. "Unrecognized Message Type")))
