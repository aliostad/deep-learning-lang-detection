;;   Copyright (c) 2015 James Gatannah. All rights reserved.
;;   The use and distribution terms for this software are covered by the
;;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;;   which can be found in the file epl-v10.html at the root of this distribution.
;;   By using this software in any fashion, you are agreeing to be bound by
;;   the terms of this license.
;;   You must not remove this notice, or any other, from this software.

(ns penumbra.system
  (:require #_[clojure.core.async :as async]
            ;; Q: Debug only??
            #_[clojure.tools.trace :as trace]
            [com.stuartsierra.component :as component]
            [penumbra
             [base :as base]
             [configuration :as config]]
            [penumbra.app
             [manager :as manager]
             ;; The rest of these are, for now, parts
             ;; associated with an App/Stage.
             ;; That seems wrong, but I still nood to work
             ;; through the implications and details.
             #_[controller :as controller]
             #_[event :as event]
             #_[input :as input]
             #_[queue :as queue]
             #_[window :as window]]))

(defn base-map
  [overriding-config-options]
  (comment :app (app/ctor (select-keys overriding-config-options [:callbacks
                                                                  :clock
                                                                  :event-handler
                                                                  :main-loop
                                                                  :parent
                                                                  :queue
                                                                  :state
                                                                  :threading]))
           :controller (controller/ctor (select-keys overriding-config-options []))
           :input (input/ctor overriding-config-options)
           :event-handler (event/ctor overriding-config-options)
           :queue (queue/ctor overriding-config-options)
           :window (window/ctor (select-keys overriding-config-options [:hints
                                                                        :position
                                                                        :title])))
  (component/system-map
         :base (base/ctor (select-keys overriding-config-options [:error-callback]))
         :done (promise)
         :manager (manager/ctor {})))

(defn dependencies
  [initial]
  (component/system-using initial
   {;; seems wrong to tie an app to a single window
    ;; But that's really all it is...the infrastructure that ties together
    ;; all the pieces that manage a particular window
    ;; It doesn't belong here, though:
    ;; Some wrapper creates this System, then the AppManager handles
    ;; all the Apps (tonight I'm calling them Stages)
    ;;:app [:controller :done :event-handler :queue :window]
    ;;:input [:app]
    :manager [:done]
    ;;:queue [:controller]
    ;;:window [:base]
    }))

(defn init
  [overriding-config-options]
  (set! *warn-on-reflection* true)
  (let [cfg (into (config/defaults) overriding-config-options)]
    ;; TODO: I really need to configure logging...don't I?
    (-> (base-map cfg)
        (dependencies))))




