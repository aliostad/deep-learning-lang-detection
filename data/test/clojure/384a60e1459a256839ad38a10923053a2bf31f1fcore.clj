(ns qbits.casyn.cluster.core
  (:require
   [qbits.casyn.cluster :refer [add-node remove-node select-node
                                get-balancer get-pool get-options refresh
                                shutdown
                                PCluster PDiscoverable]]
   [clojure.set :refer [difference]]
   [clojure.tools.logging :as log]
   [qbits.knit :as knit]
   [qbits.casyn.utils :as u]
   [qbits.casyn.balancer :as b]
   [qbits.casyn.pool :as p]
   [qbits.casyn.client :as c]
   [qbits.casyn.balancer.least-loaded :as bll]
   [qbits.casyn.balancer.round-robin :as brr]
   [qbits.casyn.auto-discovery :as discovery]
   [qbits.casyn.pool.commons :as commons-pool])

  (:import
   [org.apache.commons.pool.impl GenericKeyedObjectPool]))

(deftype Cluster [balancer pool cf-pool auto-discovery-worker options]
  PCluster

  (get-pool [cluster] pool)
  (get-balancer [cluster] balancer)
  (get-options [cluster] options)

  (select-node [cluster avoid-node-set]
    (b/select-node balancer pool avoid-node-set))

  (add-node [cluster node-host]
    (log/info :cluster.node.add node-host)
    (p/add pool node-host)
    (b/register-node balancer node-host))

  (remove-node [cluster node-host]
    (log/info :cluster.node.remove node-host)
    (p/drain pool node-host)
    (b/unregister-node balancer node-host))

  (shutdown [cluster]
    (discovery/shutdown auto-discovery-worker)
    (.shutdown ^java.util.concurrent.ExecutorService (:callback-executor options))
    (p/close pool))

  PDiscoverable
  (refresh [cluster active-nodes]
    (let [current-nodes-hosts (into #{} (b/get-nodes balancer))]
      (doseq [node-host (difference active-nodes current-nodes-hosts)]
        (add-node cluster node-host))
      (doseq [node-host (difference current-nodes-hosts active-nodes)]
        (remove-node cluster node-host)))))

(defn defaults []
  {:auto-discovery? true
   :load-balancer-strategy :round-robin
   :num-selector-threads 3
   :client-timeout 0
   :callback-executor (knit/executor :cached
                                     :thread-factory (knit/thread-factory))})

(defn make-cluster
  "Returns a cluster instance, this will be used to spawn client-fns and set
defaults configurations for nodes balancer, client timeouts, nodes discovery,
and manage the selector threads pool.

hosts can be a sequence or a single value, port will be the same for
all the hosts, you can manage a fixed sized cluster with predetermined
ips by turning auto-discovery off.

  options are:

   :auto-discovery? -> true (updates balancer with new/lost nodes)

   :load-balancer-strategy -> :round-robin or :least-loaded (sets balancer strategy)

   :num-selector-threads -> 3 (numer of Selector Threads to be used by clients)

   :callback-executor -> Task Executor on which the callbacks will run, defaults to a newCachedThreadPool

   :client-timeout -> Timeout on thrift clients

   :pool -> see qbits.casyn.pool.commons/make-pool options"
  [hosts port keyspace & options]
  (let [opts (merge (defaults) (apply array-map options))
        {:keys [auto-discovery? load-balancer-strategy
                num-selector-threads pool callback-executor failover]} opts
        cf-pool (c/client-factory-pool num-selector-threads)
        auto-discovery-worker (when auto-discovery? (discovery/make-worker))
        cluster (Cluster. (b/balancer load-balancer-strategy)
                          (apply commons-pool/make-pool port keyspace
                                 cf-pool
                                 callback-executor
                                 (mapcat identity pool))
                          cf-pool
                          auto-discovery-worker
                          opts)]
    (if (sequential? hosts)
      (doseq [host hosts]
        (add-node cluster (u/host->ip host)))
      (add-node cluster (u/host->ip hosts)))

    (when auto-discovery?
      (discovery/start auto-discovery-worker cluster 2000))

    cluster))
