(ns herald.console
  (:require-macros
    [cljs.core.async.macros :refer [go go-loop]])
  (:require [cljs.core.async :refer [<! close! alts! timeout]]))


(defn log<
  "logs all incoming messages"
  [log-ch]
  (go-loop []
    (when-let [log (<! log-ch)]
      (let [log-fn (case (:level log)
                     :error #(.error js/console %1)
                     :warn #(.warn js/console %1)
                     :info #(.info js/console %1)
                     #(.debug js/console %1))]
        (log-fn (str "log" (:level log) ": " (:msg log)))
        (when (:data log)
          (log-fn (:data log))))
      (recur))))

(defn error<
  "manage all error pushed into error channel"
  [error-ch]
  (go-loop []
    (let [error (<! error-ch)]
      (.error js/console (str "error:" (:error error) ": " (:msg error)))
      (.error js/console (str (:data error)))
      (recur))))


