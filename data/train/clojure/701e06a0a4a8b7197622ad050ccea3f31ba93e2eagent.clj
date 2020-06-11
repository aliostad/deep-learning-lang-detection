(ns zhang.agent
  "Zhang agent."
  (:require [clojang.agent :as agent]
            [clojang.agent.const :as const]
            [clojang.agent.startup :as clojang-startup]
            [clojure.tools.logging :as log]
            [clojusc.twig :as logger]
            [dire.core :refer [with-handler!]]
            [trifl.net :as net]
            [zhang.agent.startup :as zhang-startup])
  (:import [java.lang.instrument])
  (:gen-class
    :methods [^:static [premain [String java.lang.instrument.Instrumentation] void]]))

(defn -premain
  [args instrument]
  (logger/set-level! '[clojang zhang] :info)
  (zhang-startup/perform-management-tasks)
  (zhang-startup/perform-node-tasks (agent/get-node-name))
  (if-not (agent/headless?)
    (clojang-startup/perform-gui-tasks)))
