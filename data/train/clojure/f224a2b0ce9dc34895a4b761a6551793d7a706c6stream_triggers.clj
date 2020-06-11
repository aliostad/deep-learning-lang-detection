(ns jiksnu.modules.atom.triggers.stream-triggers
  (:require [clojure.tools.logging :as log]
            [jiksnu.actions.activity-actions :as actions.activity]
            [jiksnu.actions.conversation-actions :as actions.conversation]
            [jiksnu.actions.stream-actions :as actions.stream]
            [jiksnu.channels :as ch]
            [jiksnu.ops :as ops]
            [lamina.core :as l]))

(defn handle-pending-create-stream*
  [params]
  (actions.stream/create params))

(def handle-pending-create-stream
  (ops/op-handler handle-pending-create-stream*))

(defn init-receivers
  []

  (l/receive-all ch/pending-create-stream #'handle-pending-create-stream)

  )

(defonce receivers (init-receivers))

