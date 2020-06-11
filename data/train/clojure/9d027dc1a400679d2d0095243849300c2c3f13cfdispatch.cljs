;;   Copyright (c) 7theta. All rights reserved.
;;   The use and distribution terms for this software are covered by the
;;   Eclipse Public License 1.0 (http://www.eclipse.org/legal/epl-v10.html)
;;   which can be found in the LICENSE file at the root of this
;;   distribution.
;;
;;   By using this software in any fashion, you are agreeing to be bound by
;;   the terms of this license.
;;   You must not remove this notice, or any others, from this software.

(ns re-frame-fx.dispatch
  (:require [re-frame.core :refer [reg-fx dispatch]]))

(def ^:private deferred-actions (atom {}))

;;; Public

(reg-fx
 :dispatch-debounce
 (fn [dispatch-map-or-seq]
   (let [cancel-timeout (fn [id]
                          (when-let [deferred (get @deferred-actions id)]
                            (js/clearTimeout (:timer deferred))
                            (swap! deferred-actions dissoc id)))
         run-action (fn [action event]
                      (cond
                        (= :dispatch action) (dispatch event)
                        (= :dispatch-n action) (doseq [e event]
                                                 (dispatch e))))]
     (doseq [{:keys [id timeout action event]}
             (cond-> dispatch-map-or-seq
               (not (sequential? dispatch-map-or-seq)) vector)]
       (cond
         (#{:dispatch :dispatch-n} action)
         (do (cancel-timeout id)
             (swap! deferred-actions assoc id
                    {:timer (js/setTimeout (fn []
                                             (cancel-timeout id)
                                             (run-action action event))
                                           timeout)}))

         (= :cancel action)
         (cancel-timeout id)

         (= :flush action)
         (when-let [{:keys [id action event]} (get @deferred-actions id)]
           (cancel-timeout id)
           (run-action action event))

         :else
         (throw (js/Error (str ":dispatch-debounce invalid action " action))))))))
