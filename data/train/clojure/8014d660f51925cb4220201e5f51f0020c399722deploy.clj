(ns stack.wiring.commands.deploy
  (:require [stack.commands.deploy :as deploy]
            [stack.util :as util]
            [stack.wiring.aws.cloudformation :as cloudformation]
            [stack.wiring.commands.events :as events]
            [stack.wiring.commands.signal :as signal]))

(def dispatch-events
  (deploy/dispatch-events-fn
    :events-fn events/dispatch))

(def dispatch-signal
  (deploy/dispatch-signal-fn
    :signal-fn signal/dispatch))

(def dispatch-parallel-actions
  (deploy/dispatch-parallel-actions-fn
    :actions [dispatch-events
              dispatch-signal]))

(def action
  (deploy/action-fn
    :error-fn util/error-fn
    :deploy-fn cloudformation/deploy-stack
    :after-fn dispatch-parallel-actions))

(def handle-args
  (util/make-handler-fn
    {:error-fn util/error-fn
     :action-fn action
     :usage-fn (util/make-print-usage-fn deploy/usage)}))

(def dispatch
  (util/make-dispatch-fn
    :flags deploy/flags
    :handler-fn handle-args))
