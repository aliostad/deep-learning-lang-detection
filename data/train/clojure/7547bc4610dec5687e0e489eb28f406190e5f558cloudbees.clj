(ns leiningen.cloudbees
  (:use [leiningen.help :only (help-for)])
  (:require [leiningen.ring.uberwar :as war]
            [clojure.java.io]))

(def endpoint "https://api.cloudbees.com/api")

(defn- cb-client [project]
  (doto (new com.cloudbees.api.BeesClient
          (or (:cloudbees-api-url project) endpoint)
          (:cloudbees-api-key project)
          (:cloudbees-api-secret project)
          "xml"
          "1.0") (.setVerbose false)))

(defn list-apps
  "List the current applications deployed to CloudBees."
  [client project]
  (doall (map
           (fn [info] (println (. info getId) " - " (. info getStatus)))
           (. (. client applicationList) getApplications))))

;; todo should have account in project, and pass in name from command line - secrets?
(defn- deploy-app
  [client project]
  (println "Deploying app to CloudBees, please wait....")
  (println (.
             (. client applicationDeployWar (:cloudbees-app-id project) nil nil (clojure.java.io/file "target/.project.zip") nil true nil)
             getUrl))
  (println "Application deployed."))

(defn deploy
  "Deploy the ring application to CloudBees."
  [client project]
  (war/uberwar project ".project.zip")
  (deploy-app client project))

(defn tail
  "Tail the runtime log of the deployed application."
  ([client project]
    (tail client project "server"))
  ([client project logname]
    (. client tailLog (:cloudbees-app-id project) logname (. System out))))

(defn restart
  "Restart the deployed application."
  [client project]
  (. client applicationRestart (:cloudbees-app-id project)))

(defn stop
  "Stop the deployed application."
  [client project]
  (. client applicationStop (:cloudbees-app-id project)))

(defn start
  "Start the deployed application."
  [client project]
  (. client applicationStart (:cloudbees-app-id project)))

(defn- contains-element? [project key msg]
  (if (contains? project key) true (println "ERROR: Missing project config item" key msg)))

(defn- validate [project]
  (and
    (contains-element? project :cloudbees-api-key "- The api key is the id provided by cloudbees.")
    (contains-element? project :cloudbees-api-secret "- The api secret is the secret key from grandcentral.cloudbees.com")
    (contains-element? project :cloudbees-app-id "- The appid is the account name/app name: for example acme/appname")))

(defn- user-prop
  "Returns the system property for user.<key>"
  [key]
  (System/getProperty (str "user." key)))

(def home-dir (user-prop "home"))

(def bees-config-file (str home-dir "/.bees/bees.config"))

(defn- bees-config? [] (.exists (java.io.File. bees-config-file)))

(defn- load-props
  [file-name]
  (with-open [^java.io.Reader reader (clojure.java.io/reader file-name)]
    (let [props (java.util.Properties.)]
      (.load props reader)
      (into {} (for [[k v] props] [(keyword k) v])))))

(defn- bees-config []
  (try
    (load-props (str home-dir "/.bees/bees.config"))
    (catch java.io.IOException e {})))

(defn- merge-transpose
  ([map mapfrom key keyfrom]
    (if (contains? map key)
      map
      (if (contains? mapfrom keyfrom)
        (assoc map key (mapfrom keyfrom))
        map)))
  ([map mapfrom key keyfrom & ks]
   (let [ret (merge-transpose map mapfrom key keyfrom)]
     (if ks
       (recur ret mapfrom (first ks) (second ks) (nnext ks))
       ret))))

(def subtasks [#'list-apps #'deploy #'tail #'restart #'stop #'start])

(def arglist (map #(:name (meta %)) subtasks))

(def subtasks-table (zipmap (map #(str %) arglist) (map #(var-get %) subtasks)))

(defn cloudbees
  "Manage a ring-based application on Cloudbees."
  {:help-arglists (list (vec arglist))
   :subtasks subtasks}
  ([project]
    (println (help-for "cloudbees")))
  ([project subtask & args]
    (let [project (merge-transpose project (bees-config) :cloudbees-api-key :bees.api.key :cloudbees-api-secret :bees.api.secret)]
      (if (validate project)
        (if-let [f (get subtasks-table subtask)]
          (apply f (cb-client project) project args)
          (throw (IllegalArgumentException. (str "No sub-task " subtask))))))))
