(ns brainbot.nozzle.manage
  (:require [clojure.core.async :refer [go thread chan mult put! close! <! <!! >! >!! timeout] :as async])
  (:require [brainbot.nozzle.routing-key :as rk]
            [brainbot.nozzle.sys :as sys]
            [brainbot.nozzle.inihelper :as inihelper]
            [brainbot.nozzle.dynaload :as dynaload]
            [brainbot.nozzle.worker :as worker]
            [brainbot.nozzle.mqhelper :as mqhelper]
            [brainbot.nozzle.vfs :as vfs])
  (:require [robert.bruce :refer [try-try-again]])
  (:require [clojure.tools.logging :as logging]
            [clj-logging-config.log4j :as log-config])
  (:require [clojure.data.json :as json])
  (:require [langohr.http :as rmqapi]
            [langohr.basic :as lb]
            [langohr.core :as rmq]
            [langohr.channel :as lch]))


(defn filter-by-vhost
  [vhost coll]
  (filter #(= vhost (:vhost %)) coll))

(defn filter-by-rkmap
  [rkmap coll]
  (filter (fn [{:keys [name]}]
            (= rkmap
               (select-keys
                (rk/map-from-routing-key-string name) (keys rkmap))))
          coll))

(defn num-messages-from-queue-state
  [queue-state vhost rkmap]
  (apply + (map :messages (filter-by-rkmap rkmap (filter-by-vhost vhost queue-state)))))


(defn start-synchronization
  [rmq-settings id filesystem]
  (let [conn (rmq/connect rmq-settings)
        ch (lch/open conn)]
    (mqhelper/initialize-rabbitmq-structures
     ch "listdir" id filesystem)
    (lb/publish ch id
                (rk/routing-key-string {:id id :filesystem filesystem :command "listdir"})
                (json/write-str {:path "/"}))
    (rmq/close ch)
    (rmq/close conn)))

(defn wait-idle
  [get-num-messages]
  (go
   (loop []
     (if-let [n (<! (get-num-messages))]
       (if (zero? n)
         :idle
         (recur))))))

(defn manage-filesystem
  [rmq-settings id {:keys [fsid sleep-between-sync]} ch]
  (let [qname (rk/routing-key-string {:id id :filesystem fsid :command "*"})
        get-num-messages* #(go
                            (if-let [qstate (<! ch)]
                              (num-messages-from-queue-state qstate
                                                             (:vhost rmq-settings)
                                                             {:id  id :filesystem fsid})))]
    (go
     (loop []
       (when-let [num-messages (<! (get-num-messages*))]
         (if (zero? num-messages)
           (do
             (logging/info "starting synchronization of" qname)
             (<! (thread (start-synchronization rmq-settings id fsid)))
             ;; consume the next value since that may have been
             ;; produced before the thread was started
             (<! ch))
           (logging/info "synchronization of" qname "already running"))
         (<! (wait-idle get-num-messages*))
         (logging/info "synchronization of" qname "finished. restarting in" sleep-between-sync "seconds")
         (<! (timeout (* sleep-between-sync 1000)))
         (recur))))))


(defrecord ManageService [rmq-settings rmq-prefix filesystems qwatch-mult]
  worker/Service
  (start [this]
    (doseq [fs filesystems]
      (let [ch (chan (async/sliding-buffer 1))]
        (async/tap qwatch-mult ch)
        (manage-filesystem rmq-settings rmq-prefix fs ch)))))


(def runner
  (reify
    dynaload/Loadable
    inihelper/IniConstructor
    (make-object-from-section [this system section-name]
      (let [rmq-settings (-> system :config :rmq-settings)
            rmq-prefix (-> system :config :rmq-prefix)
            qwatch-mult (-> system :looping-qwatcher :mult)
            filesystem-names (sys/get-filesystems-for-section system section-name)
            filesystems (map #(vfs/make-additional-fs-map system %) filesystem-names)]
        (->ManageService rmq-settings rmq-prefix filesystems qwatch-mult)))))
