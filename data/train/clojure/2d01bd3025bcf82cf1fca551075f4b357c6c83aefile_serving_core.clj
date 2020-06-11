(ns puppetlabs.services.file-serving.file-serving-core
  (:require
   [clojure.java.io :as io]
   [plumbing.core :as plumbing]
   [puppetlabs.comidi :as comidi]
   [puppetlabs.ring-middleware.utils :as request-utils]
   [puppetlabs.bodgery.jruby :as jruby]
   [puppetlabs.trapperkeeper.services.status.status-core :as status-core]
   [ring.middleware.params :as params]
   [ring.util.response :as response])
  (:import
   (java.io FileNotFoundException)
   (java.nio.file Files LinkOption NoSuchFileException Path)
   (java.text SimpleDateFormat)
   (org.apache.commons.codec.digest DigestUtils)
   (org.apache.commons.io.input BoundedInputStream)))

;; Admin API

(defn build-status-callback
  "Creates a callback function that the trapperkeeper-status library
  can use to report on status."
  [context]
  (fn
    [level]
      (let [level>= (partial status-core/compare-levels >= level)]
        {:state :running
         :status (cond-> {}
                   (level>= :debug) (assoc
                                     :environments @(:environments context)
                                     :ruby_mounts @(:ruby-mounts context)))})))

(defn refresh-jruby-state!
  "Refreshes the state of environments and mount points visible to the Ruby
  layer."
  [context]
  (let [jruby-service (:jruby-service context)]
    (reset! (:environments context)
            (jruby/run-script! jruby-service "file_serving_shims/get_environments.rb"))
    (reset! (:puppet-version context)
            (jruby/run-script! jruby-service "file_serving_shims/get_puppet_version.rb"))
    (reset! (:default-permissions context)
            (->> (jruby/run-script! jruby-service "file_serving_shims/get_default_permissions.rb")
                 (into {})))
    (reset! (:ruby-mounts context)
            (jruby/run-script! jruby-service "file_serving_shims/get_mounts.rb"))))


;; File Utilities

(def links-follow
  "Functions in the java.nio namespace default to following links,
  so an empty array of options suffices."
  (into-array LinkOption []))

(def links-nofollow
  "An array of LinkOptions which prevents symlinks from being followed."
  (into-array LinkOption [LinkOption/NOFOLLOW_LINKS]))

(def unix-attributes
  "A string of 'Unix' FileAttributes to read. Oddly, these are not in the
  official Java 8 docs. However, they work and seem to be the quickest
  means of getting items like numeric uid, gid and file modes."
  "unix:mode,uid,gid,ctime,lastModifiedTime,isDirectory,isRegularFile,isSymbolicLink")

(def ruby-datestamp
  "A date format matching the default output of Ruby's Time class."
  (SimpleDateFormat. "yyyy-MM-dd HH:mm:ss Z"))

(defn as-path
  [path]
  (.toPath (io/as-file path)))

(defn read-attributes
  "Takes a string path and determines file information such as ownership,
  access times and permissions."
  ([^Path path]
   (read-attributes path false))
  ([^Path path follow-links?]
   (let [link-behavior (if follow-links? links-follow links-nofollow)]
     (into {} (Files/readAttributes path unix-attributes link-behavior)))))

(defn file-attributes
  "Takes a string path and determines file information such as ownership,
  access times and permissions."
  ([path]
   (file-attributes path false))
  ([path follow-links?]
   (let [path (-> path io/as-file .toPath)
         link-behavior (if follow-links? links-follow links-nofollow)]
     (Files/readAttributes path unix-attributes link-behavior))))

(defn attributes->mode
  "Extracts a file mode from a Files/readAttributes result."
  [attributes]
  (-> attributes
      (get "mode")
      (bit-and 07777)))

(defn attributes->type
  "Extracts the file type from a Files/readAttributes result."
  [attributes]
  (cond
    (get attributes "isRegularFile") :file
    (get attributes "isDirectory") :directory
    (get attributes "isSymbolicLink") :link
    :else :other))

(defn readlink
  [path]
  (-> path
      io/as-file
      .toPath
      Files/readSymbolicLink
      .toString))

;; TODO: Figure out how to handle "lite" versions of each hash function.
(defn file-digest
  [path checksum-type lite?]
  (with-open [input (if lite?
                      ;; Lite versions checksum just the first 512 bytes.
                      (-> path io/input-stream (BoundedInputStream. 512))
                      (-> path io/input-stream))]
    (case checksum-type
      "md5" (DigestUtils/md5Hex input)
      "sha1" (DigestUtils/sha1Hex input)
      "sha256" (DigestUtils/sha256Hex input))))

(defn file-checksum
  [path attributes checksum-type]
  (case checksum-type
    "none" {:type "none"
            :value "{none}"}
    "ctime" {:type "ctime"
             :value (str "{ctime}" (->> (get attributes "ctime")
                                        .toMillis
                                        (.format ruby-datestamp)))}
    "mtime" {:type "mtime"
             :value (str "{mtime}" (->> (get attributes "lastModifiedTime")
                                        .toMillis
                                        (.format ruby-datestamp)))}
    "md5" {:type "md5"
           :value (str "{md5}" (file-digest path "md5" false))}
    "md5lite" {:type "md5lite"
               :value (str "{md5lite}" (file-digest path "md5" true))}
    "sha1" {:type "sha1"
            :value (str "{sha1}" (file-digest path "sha1" false))}
    "sha1lite" {:type "sha1lite"
                :value (str "{sha1lite}" (file-digest path "sha1" true))}
    "sha256" {:type "sha256"
           :value (str "{sha256}" (file-digest path "sha256" false))}
    "sha256lite" {:type "sha256lite"
               :value (str "{sha256lite}" (file-digest path "sha256" true))}))

(defn file-metadata
  ([path]
   (file-metadata path "md5" false))
  ([path checksum-type follow-links?]
    (let [attributes (file-attributes path follow-links?)
          follow (if follow-links? "follow" "manage")
          base-attributes {:path path
                           :relative_path nil
                           :destination nil
                           :owner (get attributes "uid")
                           :group (get attributes "gid")
                           :mode (attributes->mode attributes)
                           :links follow}]
      (case (attributes->type attributes)

        :file (assoc base-attributes
                      :type "file"
                      :checksum (file-checksum path attributes checksum-type))
        :directory (assoc base-attributes
                           :type "directory"
                           :checksum (file-checksum path attributes "ctime"))
        :link (assoc base-attributes
                      :type "link"
                      :destination (if follow-links?
                                     nil
                                     (readlink path))
                      :checksum (file-checksum path attributes checksum-type))))))

(defn find-in-modulepath
  "Walks a modulepath and returns a path to the first existing file entry
  or nil if no existing file is found."
  [modulepath infix path]
  (some
    #(let [test-file (->> (clojure.string/replace-first path #"^/" "")
                          (io/file % infix))]
       (if (.exists test-file) (.toString test-file)))
    modulepath))

(defn subdirs
  "Return all subdirectories of a path."
  [path]
  (->> path
       io/file
       .listFiles
       (filter #(.isDirectory %))
       (map #(.toString %))))

(defn bf-walk
  "Does a breadth-first walk of a directory tree returning a list of tuples
  containing a java.nio.file.Path object for each child followed by a hash
  of its attributes."
  ([path]
   (bf-walk path false))
  ([path follow-links?]
   (let [root (as-path path)
         link-options (if follow-links?
                        links-follow
                        links-nofollow)
         walk (fn walk [[x & xs]]
                (lazy-seq
                  (let [children (->> x .toFile .listFiles (map #(.toPath %)))
                        file-info (map (juxt identity #(read-attributes % follow-links?)) children)
                        subdirs  (filter #(-> % last (get "isDirectory")) file-info)]
                    (if (and (empty? xs) (empty? subdirs))
                      file-info
                      (concat
                        file-info
                        (walk (concat xs (map first subdirs))))))))]

     (walk [root]))))

(defn stat-dirtree
  ([path]
   (stat-dirtree path false))
  ([path follow-links?]
   (let [root (as-path path)
         root-stat {:path path
                    :relative_path "."
                    :attributes (read-attributes root follow-links?)}
         relativize (fn [child]
                      {:path path
                       :relative_path (->> child
                                           first
                                           (.relativize root)
                                           .toString)
                       ;; NOTE: Copy ctime from root directory, but only for
                       ;; directories. Bug compatibility with Puppet.
                       :attributes (if (get (last child) "isDirectory")
                                     (assoc
                                       (last child)
                                       "ctime"
                                       (get-in root-stat [:attributes "ctime"]))
                                     (last child))})]
     (cons
       root-stat
       (map relativize (bf-walk path follow-links?))))))

(defn stat->metadata
  ([{:keys [path relative_path attributes]}]
   (stat->metadata "md5" false))
  ([{:keys [path relative_path attributes]} checksum-type follow-links?]
   (let [follow (if follow-links? "follow" "manage")
         base-attributes {:path path
                          :relative_path relative_path
                          :destination nil
                          :owner (get attributes "uid")
                          :group (get attributes "gid")
                          :mode (attributes->mode attributes)
                          :links follow}
         full-path (if relative_path
                     (-> (io/file path relative_path) .toString)
                     path)]
     (case (attributes->type attributes)

       :file (assoc base-attributes
                     :type "file"
                     :checksum (file-checksum full-path attributes checksum-type))
       :directory (assoc base-attributes
                          :type "directory"
                          :checksum (file-checksum full-path attributes "ctime"))
       :link (assoc base-attributes
                     :type "link"
                     :destination (if follow-links?
                                    nil
                                    (readlink full-path))
                     :checksum (try
                                 (file-checksum
                                   full-path
                                   ; NOTE: Puppet compat. The Ruby file server
                                   ; always does a stat when checksumming
                                   ; symlinks and never a lstat regardless of
                                   ; how follow-links? is set.
                                   (read-attributes (as-path full-path) true)
                                   checksum-type)
                                 ; NOTE: Puppet compat. The Ruby file server
                                 ; just rescues any failure related to symlinks
                                 ; and returns a null for the checksum value.
                                 (catch FileNotFoundException _
                                   {:type checksum-type :value (case checksum-type
                                                                 "none" "{none}"
                                                                 nil)})
                                 (catch NoSuchFileException _
                                   {:type checksum-type :value (case checksum-type
                                                                 "none" "{none}"
                                                                 nil)})))))))


;; Ring Utilities

(defn wrap-with-service-ids
  "A middleware wrapper that marks outgoing responses with a header that
  indicates they were generated by the Clojure file server. Useful for
  development and debugging"
  [handler context]
  (fn
    [request]
    (if-let [response (handler request)]
      (-> response
        (assoc-in [:headers "X-Puppetserver-Service"]
                  (str "puppetserver/clj-file-serving-service("
                       (status-core/get-artifact-version "puppetserver" "clj-file-server")
                       ")"))
        (assoc-in [:headers "X-Puppet-Version"] @(:puppet-version context))))))

(defn file-response
  [file]
  (let [response (response/file-response
                   file
                   {:allow-symlinks? true :index-files? false :root false})]
    (assoc-in response [:headers "Content-Type"] "application/octet-stream")))


;; File Content API

(defn module-file-handler
  [context]
  (fn [request]
    ;; FIXME: Lots of stuff not handled below. Ensure environment is present as
    ;; a query parameter. Ensure the requested environment is present in our
    ;; context. Ensure we only return a file, or the content of a symlink but
    ;; not directories or other special file types.
    (let [environment (get-in request [:params "environment"])
          module (get-in request [:route-params :module])
          path (get-in request [:route-params :path])
          modulepath (get-in @(:environments context) [environment "modulepath"])
          file (find-in-modulepath modulepath (str module "/files") path)]
      (if file
        (file-response file)
        (let [msg (str "Not Found: Could not find file_content modules/" (str module path))]
          (request-utils/json-response
            404
            {:message msg :issue_kind "RESOURCE_NOT_FOUND"}))))))

(defn module-plugin-handler
  [context plugin-path]
  (fn [request]
    (let [environment (get-in request [:params "environment"])
          path (get-in request [:route-params :path])
          modulepath (get-in @(:environments context) [environment "modulepath"])
          moduledirs (mapcat subdirs modulepath)
          file (find-in-modulepath moduledirs plugin-path path)]
      (if file
        (file-response file)
        (let [msg (str "Not Found: Could not find plugin " plugin-path "/" path)]
          (request-utils/json-response
            404
            {:message msg :issue_kind "RESOURCE_NOT_FOUND"}))))))

(defn file-content-handler
  [context]
  (let [module-handler (module-file-handler context)
        plugin-handler (module-plugin-handler context "lib")
        pluginfact-handler (module-plugin-handler context "facts.d")]
    (comidi/context "/puppet/v3/file_content"
      (comidi/GET ["/modules/" [#"[a-z][a-z0-9_]*" :module] [#".*" :path]] request
                  (module-handler request))
      (comidi/GET ["/plugins/" [#".*" :path]] request
                  (plugin-handler request))
      (comidi/GET ["/pluginfacts/" [#".*" :path]] request
                  (pluginfact-handler request)))))


;; File Metadata API

(defn module-metadata-handler
  [context]
  (fn [request]
    ;; FIXME: Lots of stuff not handled below. Ensure environment is present as
    ;; a query parameter. Ensure the requested environment is present in our
    ;; context. Ensure we only return a file, or the content of a symlink but
    ;; not directories or other special file types.
    (let [environment (get-in request [:params "environment"])
          module (get-in request [:route-params :module])
          path (get-in request [:route-params :path])
          modulepath (get-in @(:environments context) [environment "modulepath"])
          file (find-in-modulepath modulepath (str module "/files") path)
          follow-links? (case (get-in request [:params "links"] "manage")
                          "manage" false
                          true)
          ignore-source-permissions? (= "ignore"
                                        (get-in request [:params "source_permissions"] "ignore"))
          checksum-type (get-in request [:params "checksum_type"] "md5")]
      (if file
        (let [stat {:path file
                    :attributes (read-attributes (as-path file) follow-links?)}
              metadata (if ignore-source-permissions?
                         (as-> stat s
                               (assoc s :attributes
                                      (merge (:attributes s) @(:default-permissions context)))
                               (stat->metadata s checksum-type follow-links?))
                         (stat->metadata stat checksum-type follow-links?))]
          (response/content-type
            (request-utils/json-response 200 metadata)
            "text/pson"))
        (let [msg (str "Not Found: Could not find file_metadata modules/" (str module path))]
          (request-utils/json-response
            404
            {:message msg :issue_kind "RESOURCE_NOT_FOUND"}))))))

(defn plugin-metadata-handler
  [context plugin-path]
  (fn [request]
    (let [environment (get-in request [:params "environment"])
          path (get-in request [:route-params :path])
          modulepath (get-in @(:environments context) [environment "modulepath"])
          moduledirs (mapcat subdirs modulepath)
          file (find-in-modulepath moduledirs plugin-path path)
          follow-links? (case (get-in request [:params "links"] "manage")
                          "manage" false
                          true)
          ignore-source-permissions? (= "ignore"
                                        (get-in request [:params "source_permissions"] "ignore"))
          checksum-type (get-in request [:params "checksum_type"] "md5")]
      (if file
        (let [stat {:path file
                    :attributes (read-attributes (as-path file) follow-links?)}
              metadata (if ignore-source-permissions?
                         (as-> stat s
                               (assoc s :attributes
                                      (merge (:attributes s) @(:default-permissions context)))
                               (stat->metadata s checksum-type follow-links?))
                         (stat->metadata stat checksum-type follow-links?))]
          (response/content-type
            (request-utils/json-response 200 metadata)
            "text/pson"))
        (let [msg (str "not found: could not find plugin " plugin-path "/" path)]
          (request-utils/json-response
            404
            {:message msg :issue_kind "resource_not_found"}))))))

(defn file-metadata-handler
  [context]
  (let [module-handler (module-metadata-handler context)
        plugin-handler (plugin-metadata-handler context "lib")
        pluginfact-handler (plugin-metadata-handler context "facts.d")]
    (comidi/context "/puppet/v3/file_metadata"
      (comidi/GET ["/modules/" [#"[a-z][a-z0-9_]*" :module] [#".*" :path]] request
                  (module-handler request))
      (comidi/GET ["/plugins" [#".*" :path]] request
                  (plugin-handler request))
      (comidi/GET ["/pluginfacts" [#".*" :path]] request
                  (pluginfact-handler request)))))


;; File Metadatas API

(defn module-metadatas-handler
  [context]
  (fn [request]
    ;; FIXME: Lots of stuff not handled below. Ensure environment is present as
    ;; a query parameter. Ensure the requested environment is present in our
    ;; context. Ensure we only return a file, or the content of a symlink but
    ;; not directories or other special file types.
    (let [environment (get-in request [:params "environment"])
          module (get-in request [:route-params :module])
          path (get-in request [:route-params :path])
          modulepath (get-in @(:environments context) [environment "modulepath"])
          root (find-in-modulepath modulepath (str module "/files") path)
          follow-links? (case (get-in request [:params "links"] "manage")
                          "manage" false
                          true)
          ignore-source-permissions? (= "ignore"
                                        (get-in request [:params "source_permissions"] "ignore"))
          checksum-type (get-in request [:params "checksum_type"] "md5")
          metadata (->> (stat-dirtree root follow-links?)
                        (map (if ignore-source-permissions?
                               #(assoc % :attributes
                                       (merge (:attributes %) @(:default-permissions context)))
                               identity))
                        (map #(stat->metadata % checksum-type follow-links?)))]
      (response/content-type
        (request-utils/json-response 200 metadata)
        "text/pson"))))

(defn plugin-metadatas-handler
  [context plugin-path]
  (fn [request]
    (let [environment (get-in request [:params "environment"])
          path (get-in request [:route-params :path])
          modulepath (get-in @(:environments context) [environment "modulepath"])
          moduledirs (->> (mapcat subdirs modulepath)
                          (map #(str % "/" plugin-path))
                          (filter #(-> % io/as-file .exists)))
          follow-links? (case (get-in request [:params "links"] "manage")
                          "manage" false
                          true)
          ignore-source-permissions? (= "ignore"
                                        (get-in request [:params "source_permissions"] "ignore"))
          checksum-type (get-in request [:params "checksum_type"] "md5")
          metadata (if (empty? moduledirs)
                     (as-> modulepath p
                          (filter #(-> % io/as-file .exists) p)
                          (first p)
                          (file-metadata p)
                          (assoc p :relative_path ".")
                          (conj [] p))
                     (->> moduledirs
                          (mapcat #(stat-dirtree % follow-links?))
                          (plumbing/distinct-by :relative_path)
                          (map (if ignore-source-permissions?
                                 #(assoc % :attributes
                                         (merge (:attributes %) @(:default-permissions context)))
                                 identity))
                          (map #(stat->metadata % checksum-type follow-links?))))]
      (response/content-type
        (request-utils/json-response 200 metadata)
        "text/pson"))))

(defn file-metadatas-handler
  [context]
  (let [module-handler (module-metadatas-handler context)
        plugin-handler (plugin-metadatas-handler context "lib")
        pluginfact-handler (plugin-metadatas-handler context "facts.d")]
    (comidi/context "/puppet/v3/file_metadatas"
      (comidi/GET ["/modules/" [#"[a-z][a-z0-9_]*" :module] [#".*" :path]] request
        (module-handler request))
      (comidi/GET ["/plugins" [#".*" :path]] request
                  (plugin-handler request))
      (comidi/GET ["/pluginfacts" [#".*" :path]] request
                  (pluginfact-handler request)))))


(defn build-request-handler
  [context]
  (-> (comidi/routes
        (file-content-handler context)
        (file-metadata-handler context)
        (file-metadatas-handler context))

      comidi/routes->handler
      (wrap-with-service-ids context)
      params/wrap-params))
