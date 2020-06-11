(ns multimethods)

(defn dispatch-fn
  "Sample dispatch function for multi-call"
  [{:keys [version]}]
  version)

(defmulti multi-call dispatch-fn)

(defmethod multi-call :one [_]
  :one)

(defmethod multi-call :two [_]
  :two)

(defmethod multi-call :default [_]
  :default)

(defmulti dispatch-by-object class)

(defmethod dispatch-by-object java.util.Map
  [m]
  "This is a Map")

(defmethod dispatch-by-object java.util.HashMap
  [m]
  "This is a HashMap")

(defmethod dispatch-by-object ::custom-type
  [m]
  "This is a Custom Type")