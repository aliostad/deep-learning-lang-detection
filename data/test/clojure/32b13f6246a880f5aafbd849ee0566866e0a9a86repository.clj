(ns demense.repository
  (:require [demense.item :as item]
            [demense.eventstore :as evst]
            [clojure.string :as str]))

(def stream-prefix "item-")

(defn remove-prefix
  "Removes prefix if possible, returns the original string if not."
  [string prefix]
  (str/replace string (re-pattern (str "^" prefix)) ""))

(remove-prefix "foo-bar" "foo-")

(defn s->a
  "Converts a stream id into an aggregate id."
  [stream-id]
  (let [id (remove-prefix stream-id stream-prefix)]
    (if (= id stream-id)
      (throw (Exception. "Invalid stream id."))
      id)))

(defn a->s
  "Converts a aggregate id into an stream id."
  [id]
  (str stream-prefix id))

(defn get-by-id
  [id]
  (item/load-from-history (evst/get-events id)))

(defn save
  [item]
  (let [{:keys [:demense.item/id :demense.event/changes]} item]
    (evst/save-events id changes -1))
  item)
