(ns hotsauce.plugin
  (:require [leiningen.core.project :as project]
            [leiningen.core.main :as main]
            [clojure.pprint :as pp]
            [cemerick.pomegranate.aether :as aether]
            [clojure.edn :as edn]
            [special.core :refer [manage condition]]
            [clojure.set :as set]
            [clojure.java.io :as io])
  (:import (java.io FileNotFoundException)))

(def cwd (memoize #(get (System/getProperties) "user.dir")))

(def config-filename (memoize #(str (get (System/getProperties) "user.home") "/.hotsauce")))

(defn init-config
  "Initializes config file" []
  (spit (config-filename) (pr-str {:hotsauce-configuration ""
                                   :version                1
                                   :active                 true
                                   :projects               {}})))

(defn get-config
  "Gets the config file contents. Initializes it if needed"
  []
  (let [f #(-> (config-filename) slurp edn/read-string)]
    (try (f)
         (catch java.io.FileNotFoundException _
           (init-config)
           (f)))))

(defn update-config
  [k f & args]
  (if-let [c (get-config)]
    (spit (config-filename)
          (apply update c k f args))
    (main/abort "No configuration to update......")))

(defn dep-tree
  "Dependency tree for project"
  [{:keys [dependencies local-repo repositories offline] :as project}]
  (aether/dependency-hierarchy
    dependencies
    (aether/resolve-dependencies
      :transfer-listener :stdout
      :coordinates dependencies
      :repositories (try
                      (require 'leiningen.core.classpath)
                      ((resolve 'leiningen.core.classpath/add-auth)
                        repositories)
                      (catch java.lang.Exception _ repositories))
      :local-repo local-repo
      :offline? offline)))

(defn dep-set
  "The total set of dependencies for a project"
  [project]
  (let [a (atom #{})
        f (fn f [[[x] v]] (swap! a conj (str (if (ns x) (str x) (str (str x) "/" (str x))))) (mapv f v))]
    (mapv f (dep-tree project))
    @a))

(defn hot-project-set
  "Total set of hot projects"
  []
  (->> (get-config) :projects (filter (comp :hot second)) (map first) set))

(def hot-deps (atom nil))

(defn middleware [project]
  (when-not @hot-deps
    (reset! hot-deps #{})
    (reset! hot-deps (set/intersection (dep-set project) (hot-project-set))))
  (let []
    (if (or (:disable-hotsauce project)
            (-> (get-config) :active not)
            (condition :original nil :normally nil))
      project
      (let [hot-proj-files (map #(let [{:keys [projects active]} (get-config)]
                                   (when active (.getAbsolutePath (io/file (get-in projects [% :root]) "project.clj"))))
                                @hot-deps)
            px (map (manage project/read :original true) hot-proj-files)
            upd (fn [p k] (update p k #(concat (apply concat (map k px)) %)))
            builds-ks [:cljsbuild :builds]
            upd-build (fn [x]
                        (update x
                                :source-paths
                                (fn [paths]
                                  (concat (apply concat (map :source-paths px))
                                          paths))))
            upd-cljs-builds (fn [x]
                              (into (empty x)
                                    (map (if (map? x)
                                           (fn [[k v]] [k (upd-build v)])
                                           upd-build)
                                         x)))
            #_(fn [proj]
                (let [ks
                      upd-build identity #_(fn [build] (assoc build :====================> (map :source-paths px)) #_(update build
                                                                                                                     :source-paths
                                                                                                                     (fn [paths]
                                                                                                                       (concat (apply
                                                                                                                                 concat
                                                                                                                                 (apply concat (map :source-paths px)))
                                                                                                                               paths))))
                      x (get-in proj ks)]
                  (if x
                    (assoc-in proj ks
                              (into (empty x)
                                    (map (if (map? x)
                                           #_(fn [[k v]] [k (upd-build v)])
                                           #(vector :=========================> )
                                           upd-build)
                                         proj)))
                    proj)))
            ]
        (-> project
            (upd :source-paths)
            (upd :resource-paths)
            (upd :test-paths)
            (#(if (get-in % builds-ks)
                (update-in % builds-ks upd-cljs-builds)
                %)))))))