;; manage-topics
;;
;; it's a command line tool that manages the state of a cluster's topics
;; from an .ini file.
;;

(ns manage-topics.core
  (:require [clojure.tools.cli :refer [parse-opts]]
            [clojure-ini.core :refer [read-ini]]
            [clojure.set :refer [difference]]
            [clojure.data :refer [diff]]
            [franzy.admin.topics :refer [all-topics
                                         delete-topic!
                                         create-topic!
                                         topics-metadata]]
            [franzy.admin.configuration :refer [all-topic-configs]]
            [franzy.admin.zookeeper.client :as client])
  (:gen-class))

(defn- usage [options-summary]
  (->> ["Manage kafka topics"
        ""
        "Usage: manage-topics action [options]"
        ""
        "Options:"
        options-summary
        ""
        "Actions:"
        "  check    check that the topics are right"
        "  create   create all the topics on the cluster"
        "  delete   delete all the topics on the cluster"
        "  list     list topics on the kafka cluster"
        ""
        "Have a great day!"]
       (clojure.string/join \newline)))

(def cli-options
  [["-z" "--zookeeper HOST" "the zookeeper host"
    :default "localhost:2181"]
   ["-t" "--topics-ini PATH" "path to topics.ini file"
    :default "topics.ini"]
   ["-p" "--partitions N" "override partitions in .ini file"]
   ["-r" "--replication N" "override replication in .ini file"]
   ["-v" "--verbose" "be extra verbose"]
   ["-h" "--help"]])

(defn- error [& rest]
  (.println *err* (clojure.string/join " " rest)))

(defn- exit [status & msg-parts]
  "Exit the process with a status and message"
  (apply error msg-parts)
  (System/exit status))

;; special .ini file section whose contents should be applied to all
;; other sections
(def default-key :DEFAULT)

;; properties that may be overriden from the command line
(def overrides [:partitions :replication])

;; map of .ini file names and the options as kafka expects to see them
(def kafka-configs {:cleanup.policy "cleanup.policy"
                    :delete.retention.ms "delete.retention.ms"
                    :flush.messages "flush.messages"
                    :flush.ms "flush.ms"
                    :index.interval.bytes "index.interval.bytes"
                    :max.message.bytes "max.message.bytes"
                    :min.cleanable.dirty.ratio "min.cleanable.dirty.ratio"
                    :min.insync.replicas "min.insync.replicas"
                    :retention.bytes "retention.bytes"
                    :retention.ms "retention.ms"
                    :segment.bytes "segment.bytes"
                    :segment.index.bytes "segment.index.bytes"
                    :segment.jitter.ms "segment.jitter.ms"
                    :segment.ms "segment.ms"
                    })

(defn- get-zk-from-options [options]
  "get a zookeeper client"
  (client/make-zk-utils
   {:servers (:zookeeper options)}
   false))

(defn- get-overrides-from-options [options]
  "get configuration overrides from command line arguments"
  (into {} (for [key overrides
                 :when (not (nil? (options key)))]
             [key (options key)])))

(defn- get-target-config-from-options [options]
  "get config from an .ini file at a path defined in options"
  (let [raw-config (read-ini (:topics-ini options)
                             :comment-char \#
                             :keywordize? true)
        defaults (raw-config default-key)
        topics (dissoc raw-config default-key)
        overrides (get-overrides-from-options options)]
    (into {} (for [[k topic-config] topics]
               [k (merge defaults topic-config overrides)]))))

(defn- kafka-config-from-target-config
  "prepare a config blob with string keys to pass to kafka"
  [config]
  (into {} (for [[inikey kafkakey] kafka-configs
                 :when (config inikey)]
             [kafkakey (config inikey)])))

(defn- keywordize-keys
  "run through a hashmap and keywordize its keys"
  [string-keys]
  (into {} (for [[key val] string-keys] [(keyword key) val])))

(defn- check-extra-and-missing
  [ini-topics existing-topics]
  (doseq [missing-topic (difference (set ini-topics)
                                    (set existing-topics))]
    (error "missing topic" missing-topic))
  (doseq [excess-topic (difference (set existing-topics)
                                   (set ini-topics))]
    (error "unknown topic" excess-topic)))


(defn- check-topic-config
  [desired-topic-config actual-config]
  (doseq [desired desired-topic-config]
    (let [topic (first desired)
          desired-translated (keywordize-keys
                              (kafka-config-from-target-config
                               (desired-topic-config topic)))
          found (actual-config topic)]
      (when (not (nil? found))  ;; don't worry over missing topics
        (let [[missing-from-cluster extra-on-cluster _]
              (diff desired-translated found)]
          (when missing-from-cluster
            (error topic "config missing from cluster:" missing-from-cluster))
          (when extra-on-cluster
            (error topic "extra config on cluster:" extra-on-cluster)))))))

(defn- do-check-topics
  "check topics action"
  [options]
  (with-open [zk (get-zk-from-options options)]
    (let [config (get-target-config-from-options options)
          verbose (:verbose options)
          ini-topics (map name (keys config))
          existing-topics (all-topics zk)
          metadata (topics-metadata zk existing-topics) ;; not actually what i need
          actual-config (all-topic-configs zk)]
      ;; TODO check partitions and replication
      ;; TODO filter out __consumer_offsets
      (when verbose
        (println "checking all topics"))
      (check-extra-and-missing ini-topics existing-topics)
      (check-topic-config config actual-config))))

(defn- validate-topic-config
  "make sure we can create a topic from config"
  [topic-config]
  (cond
    (nil? (topic-config :partitions)) "partitions undefined"
    (nil? (topic-config :replication)) "replication undefined"
    :else nil))

(defn- do-create-topics
  "create topics action"
  [options]
  (with-open [zk (get-zk-from-options options)]
    (let [config (get-target-config-from-options options)
          verbose (:verbose options)
          existing-topics (all-topics zk)]
      (doseq [new-topic (difference (set (keys config))
                                    (set (map keyword existing-topics)))]
        (let [config-error (validate-topic-config (config new-topic))]
          (when config-error
            (exit 1 "cannot create" (name new-topic) "--" config-error)))
        ;; log if no diff
        (let [topic-config (config new-topic)
              partitions (Integer. (topic-config :partitions))
              replication (Integer. (topic-config :replication))
              kafka-config (kafka-config-from-target-config topic-config)]
          (when verbose
            (println "creating" new-topic)
            (println "replication" replication)
            (println "partitions" partitions)
            (println "with config" kafka-config))
          (create-topic! zk
                         (name new-topic)
                         partitions
                         replication
                         kafka-config))))))

(defn- do-delete-topics
  "delete topics action"
  [options]
  (println "deleting all topics! are you sure? type 'yes'")
  (when (not= (read-line) "yes")
    (exit 1 "bailing out"))
  ;; TODO only delete topics in the .ini, leave others be?
  ;; or have 2 commands, or a flag?
  (with-open [zk (get-zk-from-options options)]
    (doseq [topic (all-topics zk)]
      (delete-topic! zk topic))))

(defn- do-list-topics
  "list topics action"
  [options]
  (with-open [zk (get-zk-from-options options)]
    (doall (map println (sort (all-topics zk))))))

(defn- do-configure-logging
  "configure logging based on options"
  [options]
  (org.apache.log4j.BasicConfigurator/configure)
  (.setLevel (org.apache.log4j.Logger/getRootLogger)
             (if (:verbose options)
               org.apache.log4j.Level/INFO
               org.apache.log4j.Level/ERROR)))

(defn -main
  "Manage topics"
  [& args]
  (let [{:keys [options arguments errors summary]}
        (parse-opts args cli-options)]
    (when (:help options)
      (exit 0 (usage summary)))

    (do-configure-logging options)
    (case (first arguments)
      "check" (do-check-topics options)
      "create" (do-create-topics options)
      "delete" (do-delete-topics options)
      "list" (do-list-topics options)
      (exit 1 (usage summary)))))
