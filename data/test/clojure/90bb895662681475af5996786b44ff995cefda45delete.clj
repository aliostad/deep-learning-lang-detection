(ns stack.wiring.commands.delete
  (:require [stack.commands.delete :as delete]
            [stack.util :as util]
            [stack.wiring.aws.cloudformation :as cloudformation]
            [stack.wiring.commands.events :as events]))

(def dispatch-events
  (delete/dispatch-events-fn
    :events-fn events/dispatch))

(def action
  (delete/action-fn
    :error-fn util/error-fn
    :destroy-fn cloudformation/destroy-stack
    :after-fn dispatch-events))

(def handle-args
  (util/make-handler-fn
    {:error-fn util/error-fn
     :action-fn action
     :usage-fn (util/make-print-usage-fn delete/usage)}))

(def dispatch
  (util/make-dispatch-fn
    :flags delete/flags
    :handler-fn handle-args))
