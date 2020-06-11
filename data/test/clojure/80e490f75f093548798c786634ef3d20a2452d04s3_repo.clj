(ns leiningen.s3-repo
  (:require [leiningen.core.main :as main]
            [leiningen.core.classpath :refer [add-repo-auth]]
            [clojure.java.io :as io]
            [cemerick.pomegranate.aether :as aether]))

(def +USERNAME-ENV-VAR+   "S3_REPO_USERNAME")
(def +PASSPHRASE-ENV-VAR+ "S3_REPO_PASSPHRASE")

;; Snatched from leiningen's deploy.clj
(defn- abort-message [message]
  (cond (re-find #"Return code is 405" message)
        (str message "\n" "Ensure you are deploying over SSL.")
        (re-find #"Return code is 401" message)
        (str message "\n" "See `lein s3-repo help` for an explanation of how to"
             " specify credentials.")
        :else message))

(defn maybe-add
  "If the value is not nil, add it to the map (indexed by key)."
  [map [key value]]
  (if (not (nil? value))
    (assoc map key value)
    map))

(defn get-credentials
  [{:keys [url] :as repo}]
  (reduce maybe-add (second (add-repo-auth [url repo]))
          {:username (System/getenv +USERNAME-ENV-VAR+)
           :passphrase (System/getenv +PASSPHRASE-ENV-VAR+)}))

(defn deploy
  "Deploy a given artifact to S3."
  [{:keys [repo url username passphrase coords jar-filename pom-filename] :as args}]
  (when (empty? repo)
    (main/abort "Must supply a repository name."))
  (when (empty? url)
    (main/abort "Must supply a URL."))

  (let [jar-file (when jar-filename (io/file jar-filename))
        pom-file (when pom-filename (io/file pom-filename))
        coords (if (vector? coords) coords (read-string coords))
        creds (get-credentials args)]

    (when-not (and (vector? coords)
                   (symbol? (first coords))
                   (string? (second coords)))
      (main/abort "Must supply a leiningen-style coordinate vector: '[com.acme/product \"1.0.0\"]'"))
    (when-not (and jar-file (.exists jar-file))
      (main/abort "Could not load jar file:" jar-filename))
    (when (and pom-file (not (.exists pom-file)))
      (main/abort "Could not load pom file:" pom-filename))
    
    (try
      (main/info "Deploying" jar-filename "to" repo)
      (aether/deploy :repository {repo creds}
                     :coordinates coords
                     :jar-file jar-file
                     :pom-file pom-file)
      (catch org.sonatype.aether.deployment.DeploymentException e
        (when main/*debug* (.printStackTrace e))
        (main/abort (abort-message (.getMessage e)))))))

(defn read-args
  "Read the strings in key-position into keywords."
  [& args]
  (assert (even? (count args)))
  (reduce #(assoc %1 (read-string (first %2)) (second %2))
          {}
          (partition 2 args)))

(defn print-help
  []
  (println "
Leiningen plugin for managing a maven repository hosted on Amazon S3.

deploy Deploy an artifact to S3. You can convey your S3 credentials in the environment
       variables \"S3_REPO_USERNAME\" and \"S3_REPO_PASSPHRASE\" or by passing them as
       command line arguments.

       Example invocations:
       $ lein s3-repo deploy :repo com.acme.repo :url s3://com.acme.repo/release \\
              :coords '[com.acme/product \"1.0.0\"]' :jar-filename product.jar \\
              :pom-filename pom.xml
       $ lein s3-repo deploy :repo com.acme.repo :url s3://com.acme.repo/release \\
              :coords '[com.acme/product \"1.0.0\"]' :jar-filename product.jar \\
              :username \"LKJOI...\" :passphrase \"lklkasjdl...\"
"))

(defn merge-repository
  "If there are credentials provided for the repository listed in the given lib-spec,
   then add them to the spec."
  [project lib-spec]
  (->> (:repositories project)
       (filter #(= (:repo lib-spec) (first %)))
       first
       second
       (merge lib-spec)))

(defn ^:no-project-needed s3-repo
  "Manage a maven repository hosted on Amazon S3."
  [project command & args]
  (if (:3rd-party-jars project)
    (doseq [lib (:3rd-party-jars project)]
      (deploy (merge-repository project lib)))
    (case command
      "deploy" (apply (comp deploy read-args) args)
      (print-help))))