(ns monte-raft.node.leader-worker
  (:require [monte-raft.node.state :as node-state]
            [monte-raft.node.socket :as socket]
            [monte-raft.node.macros :refer [until-message-from]]
            [monte-raft.node.worker :as worker]
            [taoensso.timbre :as log]
            [zeromq.zmq :as zmq]
            [clojure.data.json :as json]
            [clojure.core.async :as async :refer [>!!]]))

(defn leader-remote
  "Get the leader remote based on the id or config object passed in."
  [id-or-config]
  (if-let [id (if (not (map? id-or-config)) id-or-config)]
    (get-in @node-state/cluster [(keyword id) :publish-binding])
    (let [config id-or-config
          leader-id @(get-in config [:state :leader-id])]
      (get-in @node-state/cluster [leader-id :publish-binding]))))

(defn is-leader?
  "Is the other-node the same as the leader process?"
  [config]
  (= (:node-id config) @(get-in config [:state :leader-id])))

(defn publish-state [publisher state-str]
  (zmq/send-str publisher state-str))

(defn leader-worker
  "Go thread used to manage the system. Establishes heartbeat
  messages, state consensus, and handles all client interactions. Node
  sub-worker"
  ([worker-config]
     (leader-worker worker-config nil))
  ([{:keys [node-id state publish-binding] :as worker-config} started-chan]
     (log/tracef "Starting leader ('%s') sending state updates on '%s'."
       @(:leader-id state) publish-binding)
     (try
       (with-open [state-publisher (doto (zmq/socket socket/ctx :pub)
                                     (zmq/bind publish-binding))]
         (log/trace "Leader worker started.")
         (and started-chan (>!! started-chan :leader))
         (worker/until-worker-terminate worker-config :leader
           (Thread/sleep 10)))
       (log/trace "Leader exiting.")
       :terminated
       (catch Throwable e (do (clojure.stacktrace/print-cause-trace e)
                              (log/errorf "Leader (%s) encountered an error." node-id)
                              (and started-chan (>!! started-chan :leader-fail)))))))
