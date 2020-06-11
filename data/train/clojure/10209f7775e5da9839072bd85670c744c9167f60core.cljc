(ns peon.core
  (:require [goog.object :as gobj]))

(defprotocol IDispatcher
  (dispatcher [this]))

(defn- get-prop
  "Copied from om next because it's private there."
  [c k]
  (gobj/get (.-props c) k))

(defn- print-warning
  [msg]
  (.error js/console (str "Warning: " msg)))

(defn- get-parent [c]
  (get-prop c "omcljs$parent"))

(declare dispatch*)

(defn- bubble-up
  [c k args]
  (if-let [parent (get-parent c)]
    ((partial dispatch* parent k) args)
    (print-warning (str "Could not find key " k " on the component tree."))))

(defn- dispatch*
  [c k args]
  (if-let [f (some->> c dispatcher k)]
    (apply f args)
    (bubble-up c k args)))

(defn dispatch
  [c k & args]
  (if (satisfies? IDispatcher c)
    (dispatch* c k args)
    (bubble-up c k args)))
