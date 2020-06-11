(ns pallet.task.crate
  "Manage available crates."
  (:require
   [alembic.still :refer [distill]]
   [clojure.edn :as edn]
   [clojure.java.io :refer [resource]]
   [clojure.pprint :refer [pprint]]
   [clojure.tools.logging :refer [debugf tracef]]
   [doric.core :refer [table]]
   [pallet.task-utils :refer [process-args]]))

(def switches
  [["-v" "--verbose" "Show verbose output" :flag true :default false]])

(def doc-str
  "Manage available crates

pallet crate [list|require]")

(def help
  (last (process-args doc-str nil switches)))

(defn metadata* []
  (edn/read-string (slurp (resource "pallet/crate/meta.edn"))))

(def crate-meta (delay (metadata*)))

(defn metadata []
  (force crate-meta))

(def repositories
  {:clojars [["clojars" {:url "https://clojars.org/repo"
                         :snapshot true
                         :release true
                         :update :always}]]})

(defn crate
  {:doc help}
  [{:keys [compute project] :as request} & args]
  (tracef "exec %s" (vec args))
  (let [[{:keys [verbose]} [action & args] doc]
        (process-args doc-str args switches)]
    (tracef "crate %s" action)
    (condp = action
      "list" (println
              (table
               [{:name :crate :title "Crate"}
                {:name :title :title "Description"}]
               (map (fn crate-list [[crate meta]]
                      (merge
                       {:crate crate}
                       (select-keys meta [:header :title])))
                    (metadata))))
      "require" (let [crate (first args)]
                  (if-let [meta (get (metadata) (keyword crate))]
                    (let [ver (first (:versions meta))]
                      (distill
                       [[(symbol (:group-id ver "com.palletops")
                                 (:artifact-id ver (str crate "-crate")))
                         (:version ver)]]
                       :repositories ((:mvn-repo meta :clojars) repositories)
                       :verbose verbose)
                      (require (symbol (str "pallet.crate." crate))))
                    (throw (ex-info (str "Unknown crate: " crate)
                                    {:exit-code 1})))))))
