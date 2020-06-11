(ns omify.core
  (:require-macros [omify.core :refer [omify]])
  (:require [goog.object :as gobj]
            [om.next :as om]
            [om.util :as util]
            [om.next.protocols :as p]))

(defn factory
  "Create a factory constructor from a component class created with
   om.next/defui."
  ([class] (factory class nil))
  ([class {:keys [validator keyfn instrument?]
           :or {instrument? true} :as opts}]
   {:pre [(fn? class)]}
   (fn self [props & children]
     (when-not (nil? validator)
       (assert (validator props)))
     (if (and om/*instrument* instrument?)
       (om/*instrument*
         {:props    props
          :children children
          :class    class
          :factory  (factory class (assoc opts :instrument? false))})
       (let [key (if-not (nil? keyfn)
                   (keyfn props)
                   (om/compute-react-key class props))
             ref (:ref props)
             ref (cond-> ref (keyword? ref) str)
             t   (if-not (nil? om/*reconciler*)
                   (p/basis-t om/*reconciler*)
                   0)]
         (js/React.createElement class
           (js/Object.assign
             #js {:key               key
                  :ref               ref
                  :omcljs$reactKey   key
                  :omcljs$value      (om/om-props props t)
                  :omcljs$path       (-> props meta :om-path)
                  :omcljs$reconciler om/*reconciler*
                  :omcljs$parent     om/*parent*
                  :omcljs$shared     om/*shared*
                  :omcljs$instrument om/*instrument*
                  :omcljs$depth      om/*depth*}
             (clj->js props)
             (clj->js (om/get-computed props)))
           (util/force-children children)))))))

;; TODO:
;; - helper for setting om next props->react-props in component for people who
;;   want to override certain component methods
;; - make `omify` and `omify!` reloadable
;; - components can't be root atm, need to bring back ~set-react-props!
