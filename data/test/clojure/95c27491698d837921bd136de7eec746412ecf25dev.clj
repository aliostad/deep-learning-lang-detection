(ns dev
  (:require [cars-router.main :as main]
            [taoensso.timbre :as l]
            [clojure.spec.test.alpha :as stest]
            [com.stuartsierra.component.repl :refer [set-init system stop start]]))

(defn reset []
  (com.stuartsierra.component.repl/reset))

(set-init (fn [_] (main/create-system {})))

(stest/instrument)

(Thread/setDefaultUncaughtExceptionHandler
         (reify
           Thread$UncaughtExceptionHandler
           (uncaughtException [this thread throwable]
             (l/error (format "!!!! Uncaught exception %s on thread %s" throwable thread) throwable)
             (.printStackTrace throwable))))
