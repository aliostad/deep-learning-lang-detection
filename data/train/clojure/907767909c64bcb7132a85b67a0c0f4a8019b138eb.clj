(ns leiningen.eb
  (:require [leiningen.eb.beanstalk :as beanstalk]
            [leiningen.eb.s3 :as s3]
            [clojure.java.io :as io])
  (:use [leiningen.help :only [help-for]]))

; significant inspiration taken from https://github.com/weavejester/lein-beanstalk

(defn info
  "Prints details about this projects deployment."
  ([project]
   (try 
     (let [app (beanstalk/get-application project)]
       (println (:name project))
       (println "Application Name:" (.getApplicationName app))
       (println "  Created       :" (.toString (.getDateCreated app)))
       (println "  Updated       :" (.toString (.getDateUpdated app)))
       (println "")
       (println "Environments    :"))

     (let [envs (beanstalk/get-environments project)]
       (doseq [env envs]
         (println "  "
                  (.getEnvironmentName env)
                  (.getVersionLabel env))))
     (println "Versions        :")
     (let [vers (beanstalk/get-versions project)]
       (doseq [ver vers]
         (println (.getVersionLabel ver))))
     (catch Exception e
       (println (.getMessage e)))))

  ([project env-name]
   (println "info" (:name project) env-name)))

(defn deploy
  "Deploy application version to environment."
  ([project]
   (println (help-for "eb")))

  ([project env version]
   (beanstalk/update-env-version project env version)))

(defn publish
  "Publish asset to the applications S3 bucket."
  ([project]
   (println (help-for "eb")))

  ([project file label]
   (let [f (io/file file)
         k (s3/gen-key f)
         ; retrieve bucket name.
         b (beanstalk/get-bucket project)]
     (print "Uploading" file "to" (str "s3://" b "/" k) "...")
     (flush)
     ; upload to S3.
     (s3/upload b k f)
     (println "done")
     (print "Publishing as label" label "...")
     (flush)
     (beanstalk/set-label project label b k)
     (println "done"))))

(defn eb
  "Manage AWS Elastic Beanstalk service."
  {:help-argslist '([info publish deploy])
   :subtasks [#'info #'publish #'deploy]}

  ([project]
   (println (help-for "eb")))

  ([project subtask & args]
   (case subtask
     "info"    (apply info project args)
     "publish" (apply publish project args)
     "deploy" (apply deploy project args)
     (println (help-for "eb")))))
