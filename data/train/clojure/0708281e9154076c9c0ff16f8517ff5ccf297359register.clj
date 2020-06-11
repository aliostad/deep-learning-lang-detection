(ns cider-spy-nrepl.hub.register
  "Manage HUB registrations."
  (:require [cider-spy-nrepl.common :as common]
            [cider-spy-nrepl.ns-trail :as ns-trail]
            [cider-spy-nrepl.middleware.session-vars :refer [*tracking*]])
  (:import (org.joda.time LocalDateTime)))

(def sessions (atom {}))

(def update! common/update-atom!)

(defn- determine-alias [sessions alias]
  (let [current-aliases (set (map (comp :alias deref) (vals sessions)))]
    (or (and (not (current-aliases alias)) alias)
        (first (remove current-aliases (map #(str alias "~" %) (range 2 100))))
        (throw (Exception. (str "Alias in use up to 100: " alias))))))

(defn- update-sessions! [sessions session id alias]
  (let [alias (determine-alias sessions alias)]
    (swap! session assoc :id id :alias alias)
    (assoc sessions id session)))

(defn register!
  "Register the session.
   This will also update the session with session-id and alias."
  [session id alias]
  (swap! sessions update-sessions! session id alias))

(defn unregister!
  "Unregister the session."
  [session]
  (update! sessions dissoc (:id @session)))

(defn aliases
  "Return aliases of registered sessions."
  []
  (map (comp :alias deref) (vals @sessions)))

(defn session-from-alias [alias]
  (first (filter (comp (partial = alias) :alias deref)
                 (vals @sessions))))

(defn channels
  "Return channels of registered sessions."
  []
  (map (comp :channel deref) (vals @sessions)))

(defn users
  "Return a map of users and the location of where they currently are."
  []
  (into {}
        (for [[id s] @sessions]
          (let [alias (:alias @s)
                ns-trail (get-in @s [#'*tracking* :ns-trail])
                nses (take 3 (ns-trail/top-nses (LocalDateTime.) ns-trail))]
            [id {:alias alias :nses nses}]))))
