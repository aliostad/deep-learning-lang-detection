(ns hypercrud.state.actions.internal
  (:require [clojure.set :as set]
            [hypercrud.client.http :as http]
            [hypercrud.state.core :as state]
            [promesa.core :as p]))

; batch doesn't make sense with thunks (can be sync or async dispatches in a thunk),
; user beware
(defn batch [& action-list] (cons :batch action-list))

; force is a hack to be removed once this function runs in node
(defn hydrate-until-queries-settle!
  ([dispatch! get-state hydrate-id force]
   (hydrate-until-queries-settle! dispatch! get-state hydrate-id force state/*request*))
  ([dispatch! get-state hydrate-id force request-fn]
   (let [{:keys [entry-uri ptm stage] :as state} (get-state)
         ; if the time to compute the requests is long
         ; this peer could start returning inconsistent data compared to the state value,
         ; however another hydrating action should have dispatched in that scenario,
         ; so the resulting computation would be thrown away anyway
         requests (into #{} (request-fn state))]
     ; inspect dbvals used in requests see if stage has changed for them
     (if (or force (not (set/subset? requests (set (keys ptm)))))
       (p/then (http/hydrate! entry-uri requests stage)
               (fn [{:keys [t pulled-trees-map tempid-lookups]}]
                 (when (= hydrate-id (:hydrate-id (get-state)))
                   (dispatch! [:set-ptm pulled-trees-map tempid-lookups])
                   (hydrate-until-queries-settle! dispatch! get-state hydrate-id false request-fn))))
       (p/resolved nil)))))

(defn hydrating-action
  ([aux-actions dispatch! get-state]
   (hydrating-action aux-actions dispatch! get-state false))
  ([{:keys [on-start]} dispatch! get-state force]
   (let [o-stage (:stage (get-state))
         hydrate-id (js/Math.random)                        ; todo want to hash state
         ]
     ; todo assert on-start is not a thunk
     (dispatch! (apply batch [:hydrate!-start hydrate-id] (if on-start (on-start get-state))))
     (-> (hydrate-until-queries-settle! dispatch! get-state hydrate-id
                                        (or force (not= o-stage (:stage (get-state)))))
         (p/then (fn []
                   (when (= hydrate-id (:hydrate-id (get-state)))
                     (dispatch! [:hydrate!-success]))))
         (p/catch (fn [error]
                    (when (= hydrate-id (:hydrate-id (get-state)))
                      (dispatch! [:hydrate!-failure error]))))))
   nil))
