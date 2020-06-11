(ns jsk.conductor.agent-tracker)

;  "Tracking of jobs, agents and status."

;; Data shape:
;;
;; {:agents
;;  {agent-id-1 {:last-hb timestamp
;;               :jobs #{1 829 28 74}}}}

(defn new-tracker
  "Create a new tracker."
  []
  {:agents {}})

(defn add-agent
  "Adds the agent specified by agent-id to the tracker t."
  [t agent-id ts]
  (assert (-> agent-id nil? not) "nil agent-id")
  (assoc-in t [:agents agent-id] {:last-hb ts
                                  :jobs #{}}))

(defn rm-agent
  "Removes the agent specified by agent-id from the tracker t.
   Also removes any jobs and heartbeat information attached to this agent."
  [t agent-id]
  (update-in t [:agents] dissoc agent-id))

(defn rm-agents
  "Removes the agents specified by agent-ids from the tracker t."
  [t agent-ids]
  (reduce (fn[trkr id] (rm-agent trkr id))
          t
          agent-ids))

(defn agent-heartbeat-rcvd
  "Agent heartbeat received."
  [t agent-id ts]
  (assoc-in t [:agents agent-id :last-hb] ts))

(defn- manage-agent-job-assoc [t agent-id job-id f]
  (update-in t [:agents agent-id :jobs] f job-id))

(defn add-agent-job-assoc [t agent-id & job-ids]
  (update-in t [:agents agent-id :jobs] into (flatten job-ids)))

(defn add-job-agent-assocs
  "job-agent-map is a map of job ids to the agent"
  [t job-agent-map]
  (reduce (fn [ans [job-id agent-id]]
            (update-in ans [:agents agent-id :jobs] conj job-id))
          t
          (seq job-agent-map)))

(defn rm-agent-job-assoc
  "Removes the job from this tracker."
  [t agent-id job-id]
  (update-in t [:agents agent-id :jobs] disj job-id))

(defn agents
  "Answers with all the agent ids."
  [t]
  (-> t :agents keys))

(defn agent-exists?
  "Answers if the agent exists."
  [t agent-id]
  (-> t (get-in [:agents agent-id]) nil? not))

(defn last-heartbeat
  "Last received heartbeat timestamp (milliseconds) for the agent."
  [t agent-id]
  (get-in t [:agents agent-id :last-hb]))


(defn dead-agents
  "Answers with a seq of agent-ids whose last heartbeat is older than ts.
   ts is the time in milliseconds."
  [t ts]
  (filter #(< (last-heartbeat t %1) ts) (agents t)))

(defn agent-jobs
  "Answers with a set of the agents jobs"
  [t agent-id]
  (get-in t [:agents agent-id :jobs]))

(defn dead-agents-job-map
  "Answers with a map of agent-ids to a set of their jobs"
  [t ts]
  (reduce (fn[m id] (assoc m id (agent-jobs t id)))
          {}
          (dead-agents t ts)))
