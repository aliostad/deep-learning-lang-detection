(ns flux-challenge-reagent.sith-lords
  "Manages the list of Sith Lords to display on the dashboard."
  (:require [reagent.core :as r]
            [flux-challenge-reagent.scrollable-list :as scrollable-list]
            [flux-challenge-reagent.current-planet :as current-planet]
            [flux-challenge-reagent.sith-lord :as sith-lord]))

(defonce state (r/atom nil))

(defn some-item?
  "Returns true if any item matches the provided predicate."
  [pred]
  (some pred @state))

(defn- manage-requests!
  "If the interface is frozen, cancels all pending requests.
  Otherwise, start requests for items that are waiting to be requested."
  [items current-planet]
  (let [frozen (some (sith-lord/homeworld-matches? current-planet) items)
        response-handler (fn [item]
                           (swap! state #(-> %
                                             (scrollable-list/accept-loaded-item item)
                                             (manage-requests! @current-planet/state))))
        f (if frozen
            sith-lord/abort-request!
            (sith-lord/start-request! response-handler))]
    (vec (map f items))))

(defn scroll!
  "Scrolls n times the Sith Lords list in the provided direction."
  [n direction]
  (swap! state scrollable-list/scroll! n direction))

(defn init!
  "Initializes the state with an initial list starting with Darth Sidious,
  and requests Darth Sidious data to the server."
  []
  (let [darth-sidious (sith-lord/new-item 3616)
        items (scrollable-list/new-list 5 darth-sidious)]
    (reset! state (manage-requests! items @current-planet/state))))

(add-watch current-planet/state :current-planet-watcher
           (fn [key a old-planet new-planet]
             (swap! state manage-requests! new-planet)))
