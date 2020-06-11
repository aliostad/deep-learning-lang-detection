(ns sample-app.main
  (:require [hypercrud.browser.routing :as routing]
            [hypercrud.client.internal :refer [transit-decode]]
            [hypercrud.client.peer :as peer]
            [hypercrud.state.actions.core :as actions]
            [hypercrud.state.core :as state]
            [hypercrud.state.reducers :as reducers]
            [hypercrud.types.URI :refer [->URI]]
            [pushy.core :as pushy]
            [reagent.core :as reagent]
            [sample-app.core :as app]))


(enable-console-print!)

(def service-uri (->URI "http://localhost:8080/api/"))

(def ui
  (reagent/create-class
    {:reagent-render (fn [state-atom history dispatch! ctx] [app/view state-atom ctx])

     :component-did-mount
     (fn [this]
       (let [[_ state-atom history dispatch! ctx] (reagent/argv this)]
         (add-watch state-atom :browser-sync!
                    (fn [k r o n]
                      (when (not= (:route o) (:route n))
                        (pushy/set-token! history (routing/encode (:route n))))))))

     :component-will-unmount
     (fn [this]
       (let [[_ state-atom history dispatch! ctx] (reagent/argv this)]
         (remove-watch state-atom :browser-sync!)))}))

(defn main []
  (let [state-atom (reagent/atom (-> (let [s-state (-> (js/document.getElementById "state") .-innerHTML)]
                                       (if-not (empty? s-state)
                                         (transit-decode s-state)
                                         {}))
                                     (assoc :entry-uri service-uri)
                                     (reducers/root-reducer nil)))
        dispatch! (state/build-dispatch state-atom reducers/root-reducer)
        history (pushy/pushy (fn [page-path]
                               (dispatch! (actions/set-route page-path)))
                             identity)
        ctx (let [peer (peer/->Peer state-atom)]
              {:dispatch! dispatch!
               :peer peer})]
    ; todo can we localize pushy/start and set! *request* to component-did-mount?
    (set! state/*request* #(app/request % ctx))
    (pushy/start! history)
    (reagent/render [ui state-atom history dispatch! ctx] (.getElementById js/document "root"))))
