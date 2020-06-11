(ns stack.wiring.commands.help
  (:require [stack.commands.help :as help]
            [stack.wiring.commands.deploy :as deploy]
            [stack.wiring.commands.delete :as delete]
            [stack.wiring.commands.events :as events]
            [stack.wiring.commands.signal :as signal]
            [stack.util :as util]))

(def action
  (help/action-fn
    :error-fn util/error-fn
    :subcommands [[:deploy deploy/dispatch]
                  [:delete delete/dispatch]
                  [:events events/dispatch]
                  [:signal signal/dispatch]]))

(def handle-args
  (util/make-handler-fn
    {:error-fn util/error-fn
     :action-fn action
     :usage-fn (util/make-print-usage-fn help/usage)}))

(def dispatch
  (util/make-dispatch-fn
    :flags help/flags
    :handler-fn handle-args))
