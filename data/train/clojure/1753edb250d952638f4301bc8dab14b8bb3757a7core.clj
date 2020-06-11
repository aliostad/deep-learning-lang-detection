(ns stack.core
  (:require [clojure.tools.cli :refer [parse-opts]]
            [stack.util :as util]
            [stack.wiring.commands.deploy :as deploy]
            [stack.wiring.commands.delete :as delete]
            [stack.wiring.commands.events :as events]
            [stack.wiring.commands.signal :as signal]
            [stack.wiring.commands.help :as help])
  (:gen-class))

(def flags
  "Supported command line flags"
  [["-h" "--help"
    "Show this usage info"]])

(defn implicit-help?
  [arguments options]
  (or (:help options)
      (empty? arguments)))

(defn make-dispatch-fn
  "Return a fn accepting ([& args]) and dispatching to a subcommand like git."
  [commands error-fn]
  (fn [& args]
    (let [{:keys [arguments options errors]} (parse-opts (take 1 args) flags)
          cmd-name (first arguments)]
      (if (implicit-help? arguments options)
        (recur ["help"])
        (try
          (if-let [dispatch-fn (get commands (keyword cmd-name))]
            (apply dispatch-fn (drop 1 args))
            (error-fn (str "Unknown command: " cmd-name)))
          (catch Exception e
            (binding [*out* *err*] (println (.getMessage e)))
            (System/exit 1))
          (finally (shutdown-agents)))))))

(def -main
  (make-dispatch-fn
    {:deploy deploy/dispatch
     :delete delete/dispatch
     :events events/dispatch
     :signal signal/dispatch
     :help help/dispatch}
    util/error-fn))
