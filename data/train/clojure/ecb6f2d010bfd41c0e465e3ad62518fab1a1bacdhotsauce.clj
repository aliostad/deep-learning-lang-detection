(ns leiningen.hotsauce
  "Plugin for working seamlessly on sub-projects."
  (:refer-clojure :exclude [remove])
  (:require [leiningen.core.project :as pro]
            [leiningen.core.main :as main]
            [hotsauce.plugin :as plugin]
            [clojure.string :as string]
            [clojure.pprint :as pp]
            [special.core :refer [manage condition]]
            [leiningen.core.utils :as utils]))

(declare hotsauce)

(defn as-local-path [filename]
  (let [cwd (plugin/cwd)
        filename (.getAbsolutePath (clojure.java.io/file filename))]
    (utils/relativize cwd filename)
    ; Invitation to pull request:
    ; I would a nicer relative path display here.
    ; Something with a minimal ../../x/y/z syntax,
    ; unless a full path is much shorter.
    #_(if (.startsWith filename cwd)
        (str "." (.substring filename (count cwd)))
        filename)))

(defn project-files-under-dir [dirname]
  (->> (file-seq (clojure.java.io/file dirname))
       (map (fn [file] (.getPath file)))
       (filter (partial re-matches #".*/project.clj"))))

(defn list-project-status [project projects active diag]
  (when (seq projects)
    (let [ds (plugin/dep-set project)]
      (string/join "\n"
                   (cons "  Projects:"
                         (for [{:keys [hot id root name]} (sort-by :name (vals projects))]
                           (apply str
                                  (format "   %8s %3s %-40s  %s"
                                          (if hot (str "hot " (when active "*")) "cold    ")
                                          (if (ds id) "-->" "")
                                          (if (= id (str name "/" name)) name id)
                                          (try (as-local-path root) (catch Throwable _)))
                                  (when diag (str "\n         " (with-out-str (pp/pprint (select-keys (pro/read-raw (str root "/project.clj"))
                                                                                                      [:resource-paths :source-paths :root]))))))))))
    ))

(defn show-status [project & flags]
  (let [{:keys [header empty-projects footer diag] show-projects :projects} (set flags)
        {:keys [projects active]} (plugin/get-config)]
    (str (when header
           (str "Hotsauce status:\n\n"
                (if active "  ACTIVE -- this means that all lein operations will be modified with respect to hot projects"
                           "  NOT ACTIVE -- this means that lein works as if hotsauce were not installed")
                "\n\n"
                ))
         (when show-projects
           (str (list-project-status project projects active diag)
                (when empty-projects (when-not (seq projects)
                                       "  There are no projects under hotsauce control. \n  To add a project, use the command\n    lein hotsauce add <project-dir>\n  or\n    lein hotsauce add-recursive\n"))
                "\n\n"))
         (when footer
           "For more information type\n  lein help hotsauce\nor go to\n  www.github.com/clojureman/hotsauce\n"))))

(defn set-prj-prop!
  [project-name k v]
  (when-not (get-in (plugin/get-config) [:projects project-name]))
  (plugin/update-config :projects assoc-in [project-name k] v))

(defn read-proj [path]
  (try
    (let [path (if (re-matches #".+/project.clj" (str path))
                 path
                 (str path "/project.clj"))
          x (pro/read-raw path)]
      (when (:root x) x))
    (catch Throwable _)))

(defn normalize-proj-id [group nam]
  (if (re-matches #".*\/.*" (str nam))
    (str nam)
    (str (if (seq group) group nam) "/" nam)))

(defn add-proj [{:keys [root group] nam :name}]
  (if (and root nam)
    (plugin/update-config :projects #(let [id (normalize-proj-id group nam)]
                                      (update-in % [id] assoc :name nam :id id :root root)))
    (condition :invalid-project [group nam root])))

(defn add
  "Adds one or more projects to hotsource control.
  You can specify project directories or project files."
  [project args]
  (let [e (atom nil)]
    ((manage #(->> (if (seq args)
                     (try (map read-proj args) (catch Throwable _))
                     [project])
                   (clojure.core/remove nil?)
                   (mapv add-proj))
             :invalid-project #(swap! e conj %)))
    (string/join
      "\n" (cons (show-status :projects :empty-projects)
                 (map #(str "Invalid project: " (pr-str %)) @e)))))

(defn remove-all
  "Remove all projects from the project list"
  []
  (plugin/update-config :projects (constantly {})))

(defn set-hot-cold! [project args hot]
  (doseq [nam args]
    (set-prj-prop! (if (re-matches #".*/.*" nam) nam (str nam "/" nam))
                   :hot hot))
  (show-status project :projects :empty-projects))

(defn set-on-off!
  [project active]
  (plugin/update-config :active (constantly active))
  (show-status project :header :projects :empty-projects))

(defn add-recursive
  "Add all projects under current directory to hotsauce"
  []
  (add nil (project-files-under-dir (plugin/cwd))))

(defn remove
  "Remove a project from the project list"
  [id]
  (plugin/update-config :projects dissoc id)
  (show-status :projects :empty-projects))

(defn on
  "Makes hotsauce active"
  [project]
  (set-on-off! project true))

(defn off
  "Makes hotsauce active"
  [project]
  (set-on-off! project nil))

(defn hot
  "Hot-sauce one or more projects."
  [project args]
  (set-hot-cold! project args true))

(defn cold
  "Exempt one ore more projects from hot-saucing"
  [project args]
  (set-hot-cold! project args nil))

(defn show "Show the effective project settings as lein sees them"
  [project]
  (pp/pprint project))

(defn ^:no-project-needed hotsauce
  "Spice up your clojure development with hotsauce!

  Hotsauce maintains hot source paths in a project.
  This is an alternative to using checkout dependencies.

  By hot-saucing a dependency on a clojure-project, you
  effectively \"include\" the source, test and resource directories
  of that project into the project you are building
  instead of depending on a project from a repo.

  A hot-sauced project is automatically hot-sauced in all dependent
  projects, so if you are working on multiple main projects at the
  same time, you make it hot or cold for all main projects at the
  same time.

  To put a project under hotsauce control, you must first
  add it using the add or add-recursive subcommand.

  However, hotsauce must also be active and the project hot
  in order for it to be given special treatment when a dependant
  project is built.

  For more information see www.github.com/clojureman/hotsauce"

  {:subtasks [#'add #'add-recursive #'remove
              #'hot #'cold
              #'on #'off
              #'show]}
  [project & [command & args]]
  (-> (case command
        nil (show-status project :header :projects :empty-projects :footer)
        "on" (on project)
        "off" (off project)
        "add" (add project args)
        "add-recursive" (add-recursive)
        "remove" (remove (normalize-proj-id nil (first args)))
        "remove-all" (remove-all)
        "hot" (hot project args)
        "cold" (cold project args)
        "show" (show project)
        (main/abort "Unknown hotsauce command:" command))
      (#(when % (println %)))))
