(ns ^{:doc "Contains client-side state, validators for input fields
 and functions which react to changes made to the input fields."}
 jammer.model
 (:require [one.dispatch :as dispatch]))

(def ^{:doc "An atom containing a map which is the application's current state."}
  state (atom {}))

;; The username and channel the user is on.
(def username (atom ""))
(def channel (atom ""))

;; Needed to initialize pusher
(def pusher-key "c31ce5204231d5cdd28d")

(add-watch state :state-change-key
           (fn [k r o n]
             (dispatch/fire :state-change n)))
