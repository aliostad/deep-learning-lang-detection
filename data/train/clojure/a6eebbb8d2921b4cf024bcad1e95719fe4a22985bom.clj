(ns leiningen.bom
  (:require
    [clojure.pprint :as pp]
    [leiningen.core.project :as project]
    [lein-bom.aether :as aether])
  (:import (org.sonatype.aether.resolution ArtifactDescriptorResult)
           (clojure.lang ITransientSet)))

(defn- resolve-imported-dependencies [boms {:keys [repositories offline?]}]
  (->> (aether/read-artifact-descriptors
         :coordinates (map (fn [[group-artifact version & {:keys [classifier extension scope]
                                                           :as   opts
                                                           :or   {extension "pom"
                                                                  scope     "import"}}
                                 :as dep-spec]]
                             (aether/dep-spec*
                               {:groupId    (or (namespace group-artifact) (name group-artifact))
                                :artifactId (name group-artifact)
                                :version    version
                                :classifier classifier
                                :extension  extension
                                :scope      scope
                                :optional   false
                                :exclusions nil             ;todo exclusions (https://issues.apache.org/jira/browse/MNG-5600)
                                })) boms)
         :repositories repositories
         :offline? offline?)

       (mapcat #(-> (meta %)
                    ^ArtifactDescriptorResult (:result)
                    (.getManagedDependencies)))
       (map #(aether/dep-spec %))))

(defn management-key
  [[group-artifact version & {:keys [classifier extension]
                              :as   opts :or {classifier ""
                                              extension  "jar"}}]]
  {:group      (or (namespace group-artifact) (name group-artifact))
   :artifact   (name group-artifact)
   :extension  extension
   :classifier classifier})

(defn import-dependencies
  [existing coll]
  (let [ms (reduce (fn [c d]
                     (let [s (:s c)
                           v (:v c)
                           k (management-key d)]
                       {:s (conj! s k)
                        :v (conj! v d)}))
                   {:s (transient #{}) :v (transient (vec existing))}
                   existing)
        r (persistent! (:v
                         (reduce
                           (fn [c dep]
                             (let [^ITransientSet s (:s c)
                                   v (:v c)
                                   k (management-key dep)
                                   d (.contains s k)]
                               {:s (if d s (conj! s k))
                                :v (if d v (conj! v dep))}))
                           ms coll)))]
    ;(println (type r))
    ;(pp/pprint r)
    r))

(defn manage-dependencies [project]
  (let [existing (get project :managed-dependencies)
        boms (get-in project [:bom :import])
        managed (->> (resolve-imported-dependencies boms project)
                     (import-dependencies existing))]
    (assoc {} :managed-dependencies (vec managed))))

(defn bom
  "Print managed dependencies after importing BOMs."
  [project & args]
  (pp/pprint (:managed-dependencies (manage-dependencies project))))
