(ns clojang.agent
  "Clojang JVM agent."
  (:require [clojang.agent.const :as const]
            [clojang.agent.startup :as startup]
            [clojure.tools.logging :as log]
            [dire.core :refer [with-handler!]]
            [clojusc.twig :as logger]
            [jiface.otp.messaging :as messaging]
            [jiface.otp.nodes :as nodes]
            [trifl.net :as net])
  (:import [java.lang.instrument])
  (:gen-class
    :methods [^:static [premain [String java.lang.instrument.Instrumentation] void]]))

(defn get-node-name
  "Get the node name."
  []
  (format "%s@%s"
    (if-not (nil? const/short-name)
      const/short-name
      const/long-name)
    (net/get-local-hostname)))

(defn headless?
  "Check to see if this JVM is declared as being headless."
  []
  (if (nil? const/headless)
    false
    true))

(defn -premain
  [args instrument]
  (logger/set-level! 'clojang :info)
  (startup/perform-node-tasks (get-node-name))
  (if-not (headless?)
    (startup/perform-gui-tasks)))
