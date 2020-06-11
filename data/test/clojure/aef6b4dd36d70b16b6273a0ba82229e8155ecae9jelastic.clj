(ns leiningen.jelastic
  (:use [leiningen.help :only (help-for)])
  (:import [com.jelastic JelasticMojo] 
           [org.apache.maven.plugin AbstractMojo]
           [org.apache.maven.execution MavenSession]
           [org.apache.maven.project MavenProject]
           [org.apache.maven.model Model]
           [org.apache.maven.plugin.logging Log]
           [org.apache.maven.settings Settings]))

(defn get-fields
  "Returns all fields of given instance, including fields from supertypes"
  [obj]
  (let [cls (.getClass obj)]
    (remove nil? (flatten 
                   (map #(seq (.getDeclaredFields %)) 
                        (cons cls (ancestors cls)))))))

(defn set-private!
  "Sets a new value to the private field of a given Java instance"
  [obj field-name value]
  (if-let [field (first 
                   (filter #(= (name field-name) (.getName %)) 
                           (get-fields obj)))]
    (doto field
      (.setAccessible true)
      (.set obj value))
    (throw 
      (IllegalArgumentException. 
        (str "No method found: " field-name)))))

(defn get-private
  "Gets value from a private field of a given Java instance"
  [obj field-name]
  (if-let [field (first 
                   (filter #(= (name field-name) (.getName %)) 
                           (get-fields obj)))]
    (do 
      (.setAccessible field true)
      (.get field obj))
    (throw 
      (IllegalArgumentException. 
        (str "No method found: " field-name)))))

(defn log [& s] (println (apply str s)))

(def line (apply str (repeat 60 "-")))

(def packaging "war")

(def maven-session-proxy
  (proxy [MavenSession] 
    [nil (Settings.) nil nil nil nil nil nil nil]))
 
(def maven-project-proxy
  (proxy [MavenProject] 
    [(doto (Model.)
       (.setPackaging packaging))]))

(def logger
  (proxy [Log] []
    (debug [s] (log s))
    (info  [s] (log s))
    ; TODO Will swallow the exception for now
    (error [s e] (log s))))

(def jelastic-service-proxy
  (proxy [JelasticMojo] []
    (getLog [] logger)))

(defn jelastic-service
  [apihoster environment context]
  (doto jelastic-service-proxy 
    (set-private! :api_hoster apihoster)
    (set-private! :environment environment)
    (set-private! :context context)
    (set-private! :project maven-project-proxy)
    (set-private! :mavenSession maven-session-proxy)))

(defn authenticate
  [service email password]
  (log line)
  (doto service
    (set-private! :email email)
    (set-private! :password password))
  (let [resp (.authentication service)]
    (if (zero? (.getResult resp)) 
      (do (log "Authentication      : SUCCESS")
          (log "Session             : " (.getSession resp))
          (log "Uid                 : " (.getUid resp))
          resp)
      (do (log "Authentication      : FAILED")
          (log "Error               : " (.getError resp)) 
          (throw (Exception. (.getError resp)))))))

(defn upload-file
  [service auth dir finalname]
  (set-private! service "finalName" finalname)
  (set-private! service "outputDirectory" (java.io.File. dir))
  (log line)
  (log "Trying to upload file  : " finalname "." packaging)
  (when-let [resp (try 
                    (.upload service auth) 
                    (catch Exception e
                      (do (log "File upload         : FAILED")
                          (log "File does not exist : " dir finalname "." packaging)
                          nil)))]
    (if (zero? (.getResult resp))
      (do (log "File upload          : SUCCESS")
          (log "File url             : " (.getFile resp))
          (log "File size            : " (.getSize resp))
          resp)
      (do (log "File upload          : FAILED")
          (log "Error                : " (.getError resp))
          nil))))

(defn register-file
  [service auth upload-resp]
  (log line)
  (let [resp (.createObject service upload-resp auth)]
    (if (zero? (.getResult resp))
      (do (log "File registration    : SUCCESS")
          (log "Registration ID      : " (-> resp .getResponse .getObject .getId))
          (log "Developer ID         : " (-> resp .getResponse .getObject .getDeveloper))
          resp)
      (do (log "File registration    : FAILED")
          (log "Error                : " (.getError resp)) 
          nil))))

(defn with-auth
  [project f]
  (let [{:keys [apihoster 
                context 
                environment
                email
                password]} (:jelastic project)
        service (jelastic-service apihoster environment context)
        auth    (authenticate service email password)]
    (f service auth)))

(defn default-filename
  [project]
  (str (:name project) "-" (:version project)))

(defn filename
  "Creates the filename of the uploaded file,
   allows customization through :custom-filename function from 
   project map"
  [project]
  (let [custom-filename-fn (get-in project [:jelastic :custom-filename])] 
    ((or (eval custom-filename-fn) default-filename) project)))

(defn upload
  "Upload the current project to Jelastic"
  [project service auth] 
  (let [path    (str (:target-path project) "/")
        file    (filename project)
        upload-resp (upload-file service auth path file)]
    (and 
      upload-resp 
      [upload-resp (register-file service auth upload-resp)])))

(defn deploy
  "Upload and deploy the current project to Jelastic"
  [project service auth] 
  (let [[upload-resp register-resp] (upload project service auth)]
    (log line)
    (let [deploy-resp (.deploy service auth upload-resp register-resp)]
      (if (every? zero? [(.getResult deploy-resp) (-> deploy-resp .getResponse .getResult)])
        (do (log "Deploy file         : SUCCESS")
            (log "Deploy log          : " (-> deploy-resp .getResponse .getResponses (aget 0) .getOut)))
        (do (log "Deploy file         : FAILED")
            (log "Error               : " (-> deploy-resp .getResponse .getError)))))))

(defn jelastic
  "Manage Jelastic service"
  {:help-arglists '([upload deploy])
   :subtasks [#'upload #'deploy]}
  ([project]
   (println (help-for "jelastic")))
  ([project subtask & args]
   (with-auth project
     (fn [service auth]
       (case subtask
         "upload" (upload project service auth)
         "deploy" (deploy project service auth))))))


