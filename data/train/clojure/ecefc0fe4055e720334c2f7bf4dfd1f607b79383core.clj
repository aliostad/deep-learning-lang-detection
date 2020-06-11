(ns claws.core
  (:require [amazonica.aws.ec2 :as ec2]
            [amazonica.aws.elasticloadbalancing :as elb]
            [amazonica.aws.rds :as rds]
            [amazonica.aws.cloudwatch :as cw]
            [clojure.data.json :as json]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.string :as string])
  (:gen-class claws.core))

(def cli-options
  [
    ;; list all the instances or security groups
    ["-l" "--list ENTITY" "list entity - either instances, vpcs, dbs, elbs or security_groups."]
    ["-h" "--help"]
    ])

(defn print_usage
  [summary]
  (let [usage (->> ["A program to manage and list crucial AWS data"
       ""
       "Usage: claws [options] arguments"
       ""
       "Options:"
       summary
       ""] (string/join \newline))]
    (println usage)))

(defn get-name
  [tags]
  ((reduce into {}
     (filter #(= "Name" (% :key)) tags)) :value))

(defn regions
  []
  ((ec2/describe-regions) :regions))

(defn elbs
  []
  (map #(select-keys % [:load-balancer-name :vpc-id :instances])
    (flatten
      (:load-balancer-descriptions (elb/describe-load-balancers)))))

(defn vpcs
  []
  (let [pcs (map #(select-keys % [:vpc-id :tags])
              ((ec2/describe-vpcs) :vpcs))]
    (doseq [pc pcs]
      (println (pc :vpc-id) (get-name (pc :tags))))))

(defn sgs
  ([]
    (map #(select-keys % [:group-name :group-id])
      (flatten
        ((ec2/describe-security-groups) :security-groups))))
  ([print]
    (doseq [sg (sgs)]
      (println (str (:group-id sg) " - " (:group-name sg))))))

(defn ec2-instances
  []
  (let [instances (map #(select-keys % [:instance-id :state :key-name :security-groups :private-ip-address :public-dns-name :tags])
    (flatten
      (map
        :instances (:reservations (ec2/describe-instances)))))]
    (doseq [instance instances]
      (let [id (instance :instance-id)
            status ((instance :state) :name)
            dnsname (instance :public-dns-name)
            ip-address (instance :private-ip-address)
            tags (instance :tags)]
        (println id ip-address (get-name tags) dnsname status)))))

(defn rds-dbs
  []
  (let [dbs (map #(select-keys % [:dbinstance-identifier :engine-version :dbinstance-status])
              ((rds/describe-dbinstances) :dbinstances))]
    (doseq [db dbs]
      (println (db :dbinstance-identifier)))))

(defn alarms
  []
  (let [metrics (map #(select-keys % [:threshold :namespace :alarm-name :comparison-operator :state-value :state-reason-data])
    ((cw/describe-alarms) :metric-alarms))]
    (doseq [metric metrics]
      (let [reason-data (json/read-str (metric :state-reason-data) :key-fn keyword)
            operator (metric :comparison-operator)
            threshold (metric :threshold)]
        (when (not= (metric :state-value) "OK")
          (println reason-data operator threshold))))))

(defn -main
  "I am the main."
  [& args]
  (let [{:keys [options arguments errors summary]} (parse-opts args cli-options)]
    (cond (:list options)
      (case (:list options)
        "instances" (ec2-instances)
        "security_groups" (sgs :print)
        "alarms" (println (alarms))
        "dbs" (rds-dbs)
        "vpcs" (vpcs)
        "elbs" (println (count (elbs)))
        (print_usage summary))
      :else (ec2-instances))))