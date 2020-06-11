(ns rhsm.api.tests.config_tests
  (:use [test-clj.testng :only (gen-class-testng)]
        [rhsm.gui.tasks.test-config :only (config
                                           clientcmd
                                           auth-proxyrunner
                                           noauth-proxyrunner)]
        [slingshot.slingshot :only (try+
                                    throw+)]
        [com.redhat.qe.verify :only (verify)]
        rhsm.gui.tasks.tools
        gnome.ldtp)
  (:require [clojure.tools.logging :as log]
            [rhsm.gui.tasks.tasks :as tasks]
            [rhsm.gui.tasks.tools :as tools]
            [clojure.string :as str]
            [clojure.data.json :as json]
            [clojure.core.match :refer [match]]
            [rhsm.dbus.parser :as dbus])
  (:import [org.testng.annotations
            Test
            BeforeClass
            AfterClass
            BeforeGroups
            AfterGroups
            BeforeSuite
            AfterSuite
            DataProvider]
           org.testng.SkipException
           [com.github.redhatqe.polarize.metadata TestDefinition]
           [com.github.redhatqe.polarize.metadata DefTypes$Project]))

(defn ^{BeforeSuite {:groups ["setup"]}}
  startup
  [_]
  "installs scripts usable for playing with a file /etc/rhsm/rhsm.conf"
  (tools/run-command "mkdir -p ~/bin")
  (tools/run-command "cd ~/bin && curl --insecure  https://rhsm-gitlab.usersys.redhat.com/rhsm-qe/scripts/raw/master/get-config-value.py > get-config-value.py")
  (tools/run-command "cd ~/bin && curl --insecure  https://rhsm-gitlab.usersys.redhat.com/rhsm-qe/scripts/raw/master/set-config-value.py > set-config-value.py")
  (tools/run-command "chmod 755 ~/bin/get-config-value.py")
  (tools/run-command "chmod 755 ~/bin/set-config-value.py"))

(defn ^{Test {:groups ["DBUS"
                       "API"
                       "tier2"]
              :description "Given a dbus service rhsm is active
When I call 'tree' using busctl for com.redhat.RHSM1
Then the response contains 'Attach' node
"}
        TestDefinition {:projectID [`DefTypes$Project/RedHatEnterpriseLinux7]}}
  config_object_is_available
  [ts]
  "shell
[root@jstavel-rhel7-latest-server ~]# busctl tree com.redhat.RHSM1
└─/com
  └─/com/redhat
    └─/com/redhat/RHSM1
      ├─/com/redhat/RHSM1/Config
      ├─/com/redhat/RHSM1/Entitlement
      ├─/com/redhat/RHSM1/Attach
      └─/com/redhat/RHSM1/RegisterServer
"
  (let [list-of-dbus-objects (->> "busctl tree com.redhat.RHSM1"
                                  tools/run-command
                                  :stdout
                                  (re-seq #"(├─|└─)/com/redhat/RHSM1/([^ ]+)")
                                  (map (fn [xs] (nth xs 2)))
                                  (map clojure.string/trim)
                                  (into #{}))]
    (verify (clojure.set/subset? #{"Config"} list-of-dbus-objects))))

(defn ^{Test {:groups ["DBUS"
                       "API"
                       "tier2"]
              :description "Given a dbus service rhsm is active
When I call 'introspect' using busctl for com.redhat.RHSM1
   and an interface /com/redhat/RHSM1/Attach
Then the methods list contains of methods 'AutoAttach', 'PoolAttach'
"}
        TestDefinition {:projectID [`DefTypes$Project/RedHatEnterpriseLinux7]}}
  config_methods
  [ts]
  (let [methods-of-the-object
        (->> "busctl introspect com.redhat.RHSM1 /com/redhat/RHSM1/Config"
             tools/run-command
             :stdout
             clojure.string/split-lines
             (filter (fn [s] (re-find #"[\ \t]method[\ \t]" s)))
             (map (fn [s] (clojure.string/replace s #"^([^\ \t]+).*" "$1")))
             (into #{}))]
    (verify (clojure.set/subset? #{".Get" ".Set" ".GetAll" ".Introspect"} methods-of-the-object))))

(defn ^{Test {:groups ["DBUS"
                       "API"
                       "tier2"]
              :description "Given a system is unregistered
When I call a DBus method 'GetAll' at com.redhat.RHSM1.Config object
Then the response contains of list of all configuration properties
as rhsm.conf consists of.
"}
        TestDefinition {:projectID [`DefTypes$Project/RedHatEnterpriseLinux7]}}
  getAll_using_dbus
  [ts]
  (let [[_ major minor] (re-find #"(\d)\.(\d)" (-> :true get-release :version))]
    (match major
           (a :guard #(< (Integer. %) 7 )) (throw (SkipException. "busctl is not available in RHEL6"))
           :else nil))
  (->> "subscription-manager unregister" tools/run-command)
  (let [{:keys [stdout stderr exitcode]}
        (->> (str "busctl call com.redhat.RHSM1 /com/redhat/RHSM1/Config com.redhat.RHSM1.Config GetAll")
             tools/run-command)]
    (verify (= stderr ""))
    (verify (= exitcode 0))
    (let [[response-data rest] (-> stdout dbus/parse)
          keys-of-data (keys response-data)]
      (clojure.test/is (= rest ""))
      (clojure.test/is (= (type response-data) clojure.lang.PersistentArrayMap))
      (verify (= (list "rhsmcertd" "rhsm" "logging" "server") keys-of-data))
      (clojure.test/is (= (@config :server-hostname)
             (-> response-data (get "server") (get "hostname"))))

      (clojure.test/is (= (@config :server-port)
             (-> response-data (get "server") (get "port"))))

      (clojure.test/is (= (@config :server-prefix)
                          (-> response-data (get "server") (get "prefix")))))))

(defn ^{Test {:groups ["DBUS"
                       "API"
                       "tier2"]
              :description "Given a system is unregistered
When I call a DBus method 'GetAll' at com.redhat.RHSM1.Config object
Then the response contains of list of all configuration properties
as rhsm.conf consists of.
"}
        TestDefinition {:projectID [`DefTypes$Project/RedHatEnterpriseLinux7]}}
  get_property_using_dbus
  [ts]
  (let [[_ major minor] (re-find #"(\d)\.(\d)" (-> :true get-release :version))]
    (match major
           (a :guard #(< (Integer. %) 7 )) (throw (SkipException. "busctl is not available in RHEL6"))
           :else nil))
  (->> "subscription-manager unregister" tools/run-command)
  (let [{:keys [stdout stderr exitcode]}
        (->> (str "busctl call com.redhat.RHSM1 /com/redhat/RHSM1/Config com.redhat.RHSM1.Config Get s rhsm.baseurl")
             tools/run-command)]
    (verify (= stderr ""))
    (verify (= exitcode 0))
    (let [[response-data rest] (-> stdout dbus/parse)
          keys-of-data (keys response-data)]
      (clojure.test/is (= rest ""))
      (clojure.test/is (= (type response-data) java.lang.String))
      (verify (= "https://cdn.redhat.com" response-data)))))

(defn ^{Test {:groups ["DBUS"
                       "API"
                       "tier2"]
              :description "Given a system is unregistered
When I call a DBus method 'GetAll' at com.redhat.RHSM1.Config object
Then the response contains of list of all configuration properties
as rhsm.conf consists of.
"}
        TestDefinition {:projectID [`DefTypes$Project/RedHatEnterpriseLinux7]}}
  get_section_using_dbus
  [ts]
  (let [[_ major minor] (re-find #"(\d)\.(\d)" (-> :true get-release :version))]
    (match major
           (a :guard #(< (Integer. %) 7 )) (throw (SkipException. "busctl is not available in RHEL6"))
           :else nil))
  (->> "subscription-manager unregister" tools/run-command)
  (let [{:keys [stdout stderr exitcode]}
        (->> (str "busctl call com.redhat.RHSM1 /com/redhat/RHSM1/Config com.redhat.RHSM1.Config Get s rhsm")
             tools/run-command)]
    (verify (= stderr ""))
    (verify (= exitcode 0))
    (let [[response-data rest] (-> stdout dbus/parse)
          keys-of-data (keys response-data)]
      (clojure.test/is (= rest ""))
      (clojure.test/is (= (type response-data) clojure.lang.PersistentHashMap))
      (verify (=  "https://cdn.redhat.com" (get response-data "baseurl")))
      (verify (= "/etc/pki/entitlement" (get response-data "entitlementcertdir")))
      (verify (= "/etc/pki/product" (get response-data "productcertdir"))))))

(defn ^{Test {:groups ["DBUS"
                       "API"
                       "tier2"]
              :description "Given a system is unregistered
When I call a DBus method 'Set' at com.redhat.RHSM1.Config object
Then the value in a file /etc/rhsm/rhsm.conf is changed
and subscription-manager gives me the actual value.
"}
        TestDefinition {:projectID [`DefTypes$Project/RedHatEnterpriseLinux7]}}
  set_property_using_dbus
  [ts]
  (let [[_ major minor] (re-find #"(\d)\.(\d)" (-> :true get-release :version))]
    (match major
           (a :guard #(< (Integer. %) 7 )) (throw (SkipException. "busctl is not available in RHEL6"))
           :else nil))
  (->> "subscription-manager unregister" tools/run-command)
  (let [manage_config (-> "~/bin/get-config-value.py /etc/rhsm/rhsm.conf rhsm manage_repos"
                          tools/run-command
                          :stdout
                          clojure.string/trim
                          Integer/parseInt)]
    (try
      (let [{:keys [stdout stderr exitcode]}
            (->> "busctl call com.redhat.RHSM1 /com/redhat/RHSM1/Config com.redhat.RHSM1.Config Set sv rhsm.manage_repos s 10"
                 tools/run-command)]
        (verify (= stderr ""))
        (verify (= stdout ""))
        (verify (= exitcode 0))
        (let [value (-> "~/bin/get-config-value.py /etc/rhsm/rhsm.conf rhsm manage_repos"
                        tools/run-command
                        :stdout
                        clojure.string/trim)]
          (verify (= value "10"))))
      (finally
        (tools/run-command
         (str "~/bin/set-config-value.py /etc/rhsm/rhsm.conf rhsm manage_repos "
              manage_config))))))

(gen-class-testng)
