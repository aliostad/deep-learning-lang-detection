(ns tomato-patch.dispatcher
  (:require-macros
   [cljs.core.async.macros :refer [go]])
  (:require
   [cljs.core.async :refer [chan]]))


(def callbacks (atom {}))


(defn register-callback [callback]
  (let [id (gensym)]
    (swap! callbacks assoc id callback)
    id))


(defn unregister-callback [id]
  ; TODO: make this fail harder if-not (contains? @callbacks id)?
  (swap! callbacks dissoc id))


(def is-dispatching (atom false))
(def pending-payload (atom nil))

(def is-pending (atom {}))
(def is-handled (atom {}))


(defn- invoke-callback [id]
  (let [callback (@callbacks id)]
    (assert callback
            (str "No callback with id " id))
    (swap! is-pending assoc id true)
    (callback @pending-payload)
    (swap! is-handled assoc id true)))


(defn- start-dispatching [payload]
  (let [initial-state (into {} (for [[id _] @callbacks] [id false]))]
    (reset! is-pending initial-state)
    (reset! is-handled initial-state))
  (reset! pending-payload payload)
  (reset! is-dispatching true))


(defn- stop-dispatching []
  (reset! pending-payload nil)
  (reset! is-dispatching false))


(defn wait-for [ids]
  (assert @is-dispatching
          "Cannot wait-for unless dispatching")
  (doall
   (for [id ids]
     (if (@is-pending id)
       (assert (@is-handled id)
               (str "Circular dependency when waiting-for " id))
       (invoke-callback id)))))


(defn dispatch [payload]
  (assert (not @is-dispatching)
          "Cannot dispatch while already dispatching")
  (start-dispatching payload)
  (doall
   (for [[id _] @callbacks]
     (if-not (@is-pending id)
       (invoke-callback id))))
  (stop-dispatching))


(defn dispatch-maybe [payload]
  (if @is-dispatching
    false
    (do
      (dispatch payload)
      true)))


(defn- dispatch-default [default]
  (fn [payload]
    (dispatch (merge default payload))))


(def dispatch-ui-action (dispatch-default {:source :ui}))
(def dispatch-server-action (dispatch-default {:source :server}))
