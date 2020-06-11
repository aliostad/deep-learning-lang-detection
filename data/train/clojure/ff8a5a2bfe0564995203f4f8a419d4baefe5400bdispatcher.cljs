(ns webkipedia.dispatcher)

(def stores (atom {}))

(defn store [f state]
  {:dispatch-fn f
   :state state})

(defn register
  "Register a store composed of a dispatcher function and an atom with the
  state of the store"
  ([k f state] (swap! stores assoc k (store f state)))
  ([xs] (doall (map (fn [[k f state]] (register k f state)) xs)))
  )

(defn dispatch
  "Dispatches an [action payload] to the dispatch function of the stores.
  Dispatch function will be called with [state action payload]"
  ([action] (dispatch action nil))
  ([action payload]
   (doseq [[k store] @stores]
     (let [{:keys [dispatch-fn state]} store
           current-state @state
           new-state (dispatch-fn current-state action payload)]
       (when (not= current-state new-state)
         (reset! state new-state))))))
