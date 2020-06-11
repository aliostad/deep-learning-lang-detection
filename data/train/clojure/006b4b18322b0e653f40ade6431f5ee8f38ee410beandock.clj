(ns leiningen.beandock
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.zip :as zip]
            [cheshire.core :as json]
            [leiningen.beanstalk.aws :as aws]
            [leiningen.docker :as docker])
  (:import com.amazonaws.services.elasticbeanstalk.model.CreateApplicationVersionRequest
           com.amazonaws.services.elasticbeanstalk.model.UpdateEnvironmentRequest
           com.amazonaws.services.elasticbeanstalk.model.S3Location
           com.amazonaws.services.s3.model.ObjectMetadata
           com.amazonaws.services.s3.AmazonS3Client
           java.io.ByteArrayInputStream
           java.text.SimpleDateFormat
           java.util.Date))

(defn ->json [s]
  (json/generate-string s))

(defn maybe-replace-version-v1 [dockerrun version]
  (-> dockerrun
      (update-in [:Image :Name] (fn [v]
                                    (str/replace v ":$VERSION" (str ":" version))))))

(defn parse-docker-repo
  "Returns a tuple of [namespace name version]. Version is optional, and may return nil"
  [str]
  (rest (re-find #"([^/]+)/([^:]+)(?:\:(.+))?$" str)))

(defn map-zipper [m]
  (zip/zipper
    (fn [x] (or (map? x) (map? (nth x 1))))
    (fn [x] (seq (if (map? x) x (nth x 1))))
    (fn [x children]
      (if (map? x)
        (into {} children)
        (assoc x 1 (into {} children))))
    m))

(defn maybe-replace-version-v2 [dockerrun repo version]
  (let [containers (:containerDefinitions dockerrun)]
    (update-in dockerrun [:containerDefinitions]
               (fn [containers]
                 (mapv (fn [container]
                         (let [image (-> container :image)
                               [image-ns image-name cur-version] (parse-docker-repo image)
                               image-repo (str image-ns "/" image-name)]
                           (if (and (= repo image-repo)
                                    (= "$VERSION" cur-version))
                             (assoc-in container [:image] (str image-ns "/" image-name ":" version))
                             container))) containers)))))

(defn transform-dockerrun-v1 [dockerrun version]
  (-> dockerrun
      (maybe-replace-version-v1 version)
      (->json)))

(defn transform-dockerrun-v2 [dockerrun repo version]
  (-> dockerrun
      (maybe-replace-version-v2 repo version)
      (->json)))

(defn transform-dockerrun [dockerrun repo version]
  (case (-> dockerrun :AWSEBDockerrunVersion)
    1 (transform-dockerrun-v1 dockerrun version)
    2 (transform-dockerrun-v2 dockerrun repo version)))

(defn load-dockerrun [project]
  (json/parse-stream (io/reader (io/file (-> project :root) "Dockerrun.aws.json")) keyword))

(defn dockerrun-key-name [version]
  (format "Dockerrun-%s.aws.json" version))

(defn s3-upload-file [project dockerrun version]
  (let [bucket  (aws/s3-bucket-name project)]
    (doto (AmazonS3Client. (aws/credentials project))
      (.setEndpoint (aws/project-endpoint project aws/s3-endpoints))
      (aws/create-bucket bucket)
      (.putObject bucket (dockerrun-key-name version) (ByteArrayInputStream. (.getBytes dockerrun)) (ObjectMetadata.)))
    (println "Uploaded" (dockerrun-key-name version) "to S3 Bucket" bucket)))

(defn app-version [project]
  (-> project :version (docker/replace-snapshot)))

(defn create-app-version
  [project version dockerrun-key]
  (.createApplicationVersion
   (#'aws/beanstalk-client project)
    (doto (CreateApplicationVersionRequest.)
      (.setAutoCreateApplication true)
      (.setApplicationName (aws/app-name project))
      (.setVersionLabel version)
      (.setDescription (:description project))
      (.setSourceBundle (S3Location. (aws/s3-bucket-name project) dockerrun-key))))
  (println "Created new app version" version))

(defn set-app-version [project env version]
  (assert env)
  (.updateEnvironment
   (#'aws/beanstalk-client project)
   (doto (UpdateEnvironmentRequest.)
     (.setEnvironmentId (.getEnvironmentId env))
     (.setEnvironmentName (.getEnvironmentName env))
     (.setVersionLabel version))))

(defn deploy
  "Deploy the container for the current version to EB"
  ([project]
   (println "Usage: lein beandock deploy <environment> [<version>]"))
  ([project env]
   (let [version (-> project docker/project-repo docker/latest-version)]
     (deploy project env version)))
  ([project env-name version]
   (let [repo (-> project :docker :repo)]
     (s3-upload-file project (-> (load-dockerrun project)
                                 (transform-dockerrun repo version)) version)
     (create-app-version project version (dockerrun-key-name version))
     (set-app-version project (aws/get-env project env-name) version))))

(defn beandock
  "Manage docker containers on AWS Elastic Beanstalk"
  {:help-arglists '([deploy])
   :subtasks [#'deploy]}
  [project subtask & args]
  (condp = subtask
    "deploy" (apply deploy project args)))
