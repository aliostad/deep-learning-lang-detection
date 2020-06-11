(ns ^{:doc "Contains client-side state, validators for input fields
  and functions which react to changes made to the input fields."}
  one.sample.model
  (:require [one.dispatch :as dispatch]
            [local        :as local]))

(def ^{:doc "An atom containing a map which is the application's current state."}
  state (atom {}))

(add-watch state :state-change-key
           (fn [k r o n]
             (dispatch/fire :state-change n)))

(def ^{:doc "An atom representing a collection of all open documents"}
  docs (atom {}))

(dispatch/react-to #{:document-changed}
                   (fn [_ d]
                     (if (not (nil? d))
                       (swap! docs assoc (:id d) d))
                     (local/set-item! "docs" @docs)))

(defn uuid []
  (let [chars "0123456789abcdef"
        random #(.floor js/Math (rand 16))]
    (apply str (repeatedly 32 #(get chars (random))))))

(defn now [] (.getTime (js/Date.)))

(defn session [{:keys [who id content title mode cursor born]}]
  (let [doc-state (atom (merge {} {:who     who
                                   :id      (or id (uuid))
                                   :content (or content "")
                                   :born    (or born (now))
                                   :ts      (now)
                                   :title   title
                                   :mode    (or mode "html")
                                   :cursor  (or cursor 0)}))]
    (swap! state assoc :document (:id @doc-state))
    (dispatch/fire :document-changed @doc-state)
    (add-watch doc-state :doc-state-key
               (fn [k r o n]
                 (dispatch/fire :document-changed n)))
    (fn document [command & args]
      (condp = command
        :set! (let [[k v] args]
                (swap! doc-state assoc k v :ts (now))
                (comment
                  (local/conj-item! "activity" {:id (@state :id) :ts (now)})))
        :get  (let [[key] args]
                (@doc-state key))))))

(defn remove-document [id]
  (swap! docs dissoc id)
  (dispatch/fire :document-changed))

(dispatch/react-to #{:storage-updated}
                   (fn [_ _]
                     (.log js/console ":storage-updated")
                     (comment 
                              (dispatch/fire (keyword (:document @state))))))