(ns frontend.utils.legacy
  (:require [om.core :as om :include-macros true]
            [om.next :as om-next]))

;; This value can be used as the om.core/*state* when rendering om.core
;; components. om.core, like om.next, has a mechanism to queue component state
;; changes. Unfortunately there's no great way to connect the two, so we abandon
;; om.core's here by hooking -queue-render! directly to .forceUpdate. That is,
;; om.core component state changes will no longer queue and batch, which should
;; be fine.
;;
;; Note that while om.core/*state* is meant to be the app state atom, this
;; render queue is about *component* state. Confusing, but om.core coordinates
;; component state changes using methods on the app state atom, presumably
;; because it's a handy central location to track things.
;;
;; As it turns out, om.core never used om.core/*state* to actually access the
;; app state (except in one experimental setup), so we don't need it to actually
;; be an app state atom. We just need it to implement om/IRenderQueue so that
;; component state updates happen.
(def trivial-legacy-render-queue
  (reify
    om/IRenderQueue
    (-queue-render! [_ c]
      (.forceUpdate c))
    (-get-queue [_] nil)
    (-empty-queue! [_] nil)))

(defn build-legacy
  "Use this instead of om.core/build from an om.next component's render.

  Example:

  (build-legacy person person-data)"
  ([f x] (build-legacy f x nil))
  ([f x m]
   (let [legacy-render-info (::legacy-render-info om-next/*shared*)
         next-render-info {:reconciler om-next/*reconciler*
                           :parent om-next/*parent*
                           :instrument om-next/*instrument*
                           :depth om-next/*depth*
                           :shared om-next/*shared*}]
     (binding [om/*state* trivial-legacy-render-queue
               om/*root-key* (:root-key legacy-render-info)
               om/*descriptor* (:descriptor legacy-render-info)
               om/*instrument* (:instrument legacy-render-info)
               ;; As it turns out, om/*parent* is only used to hand down the
               ;; shared map. Here, fake a parent component, whose shared map is
               ;; the real parent's shared map with ::next-render-info added in.
               om/*parent* #js {"props"
                                #js {"__om_shared"
                                     (assoc om-next/*shared*
                                            ::next-render-info next-render-info)}}]
       (om/build f x m)))))

(defn build-next
  "Use this instead of calling a factory directly from an om.core component's render.

  Example:

  (build-next person person-data)"
  ([factory] (build-next nil))
  ([factory props & children]
   (let [{:keys [::next-render-info]} (om/get-shared om/*parent*)
         legacy-render-info {:parent om/*parent*
                             :root-key om/*root-key*
                             :state om/*state*
                             :descriptor om/*descriptor*
                             :instrument om/*instrument*}]
     (binding [om-next/*reconciler* (:reconciler next-render-info)
               om-next/*parent* (:parent next-render-info)
               om-next/*instrument* (:instrument next-render-info)
               om-next/*depth* (:depth next-render-info)
               om-next/*shared* (assoc (:shared (om/get-shared om/*parent*))
                                       ::legacy-render-info legacy-render-info)]
       (apply factory props children)))))
