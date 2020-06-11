(ns com.beardandcode.components.routes
  (:require [compojure.core :refer [routes context]]
            [metrics.ring.instrument :refer [instrument]]))

(defn build-routes [routes-map]
  (if-let [routes-fn (:routes-fn routes-map)]
    (routes-fn (dissoc routes-map :routes-fn :options)
               (:options routes-map))
    (let [contexts (map (fn [[root routes-key]]
                          (let [context-routes (build-routes (routes-key routes-map))]
                            (context root [] context-routes)))
                        (:mapping routes-map))]
      (-> (apply routes contexts)
          instrument))))

(defn new-routes
  ([routes-fn] (new-routes routes-fn {}))
  ([routes-fn options]
     {:routes-fn routes-fn :options options}))

(defn new-context-routes [mapping]
  {:mapping mapping})
