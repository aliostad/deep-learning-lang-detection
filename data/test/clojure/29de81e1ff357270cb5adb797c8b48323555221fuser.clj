(ns user
  (:require [reloaded.repl :refer [system init start stop go reset set-init!]]
            [figwheel-sidecar.build-hooks.notifications]
            [aprint.core]
            [figwheel-example.core]))

(set-init! #'figwheel-example.core/dev-system)

(aprint.utils/use-method aprint.dispatch/color-dispatch :figwheel-sidecar.config/cljs-env pr)
(aprint.utils/use-method aprint.dispatch/color-dispatch figwheel_sidecar.build_hooks.notifications.DependencyFile pr)
(def p aprint.core/aprint)

(println "Now try '(swap! figwheel-example.state/state (fn [a] (update-in a [:a] inc)))'")
