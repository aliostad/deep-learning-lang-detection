(ns rex.dispatch)

(defn- dispatch-using-reducers [get-store
                                update-store
                                get-reducers
                                get-watchers
                                action]
  (let [old-store-value (get-store)]
    (update-store (fn [initial-store]
                    (reduce (fn [store reducer]
                              (let [{name :name
                                     reduce-fn :fn} reducer]
                                (reduce-fn store action)))
                            initial-store
                            (get-reducers))))
    (let [new-store-value (get-store)]
      (doseq [watcher (get-watchers)]
        (let [{callback :fn} watcher]
          (callback old-store-value
                    action
                    new-store-value))))
    (get-store)))

(defn- wrap-middleware [get-store
                        update-store
                        get-reducers
                        get-watchers
                        get-middlewares]
  (reduce (fn [accumulated-dispatch-fn middleware]
            (let [{name :name
                   middleware-fn :fn} middleware]
              (fn [action]
                (middleware-fn action
                               get-store
                               accumulated-dispatch-fn))))
          (partial dispatch-using-reducers
                   get-store
                   update-store
                   get-reducers
                   get-watchers)
          (get-middlewares)))

(defn dispatch [get-store
                update-store
                get-reducers
                get-watchers
                get-middlewares
                action]
  (let [dispatch-fn (wrap-middleware
                     get-store
                     update-store
                     get-reducers
                     get-watchers
                     get-middlewares)]
    (dispatch-fn action)))
