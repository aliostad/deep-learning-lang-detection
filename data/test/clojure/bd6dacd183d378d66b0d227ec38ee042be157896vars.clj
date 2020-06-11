;; Vars can be thought of as pointers to mutable storage locations, which can be updated on a per-thread basis.
;; When a var is created, it can be given an initial value, which is referred to its root binding.
;; Vars can be used to manage state in an isolated (thread-local) manner.
(def ^:dynamic *hbase-master* "localhost")

;; The starting and ending asterisks are conventions that denote that this var needs to be rebound before use.
;; This can be enforced by not specifying any root binding, causing the Clojure system to throw an exception when an attempt is made to use the var before binding.

(def ^:dynamic *hbase-master* "localhost")
(println "Hbase-master is:" *hbase-master*) ;;  "Hbase-master is: localhost"

(def ^:dynamic *rabbitmq-host*)
(println "RabbitMQ host is:" *rabbitmq-host*) ;; Var user/*rabbitmq-host* is unbound.  [Thrown class java.lang.IllegalStateException]

;; Whether a var has a root binding or not, when the binding form is used to update the var, that mutation is visible only to that thread.
;; If there was no root binding, other threads would see no root binding; if there was a root binding, other threads would see that value.
;; Example
(def ^:dynamic *mysql-host*)

;; dummy query fn
(defn db-query [db]
 (binding [*mysql-host* db]
 (count *mysql-host*)))

(def mysql-hosts ["test-mysql" "dev-mysql" "staging-mysql"])

(pmap db-query mysql-hosts) ;;(10 9 13)

