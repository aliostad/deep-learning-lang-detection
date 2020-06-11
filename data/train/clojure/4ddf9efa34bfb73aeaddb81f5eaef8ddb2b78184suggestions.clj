(ns experiment.models.suggestions
  (:use
   noir.core
   experiment.infra.models 
   experiment.infra.api
   [experiment.models.core]
   [experiment.models.user])
  (:import [org.bson.types ObjectId])
  (:require
   [somnium.congomongo :as mongo]
   [noir.response :as response]
   [noir.request :as request]
   [clojure.string :as str]
   [cheshire.core :as json]
   [experiment.libs.fulltext :as ft]))

;;
;; This file generates a dictionary of autoSuggest objects which
;; are used to generate a list of conditions for searching the
;; system's objects.  Right now we're doing this client side, but
;; we can easily move this to the server later and use mongo
;; to do the search rather than programmatically on the client.
;;

;; Types
(defn- gen-types []
  [{:trigger "show"
    :value "show experiment"
    :title "Experiments"}
   {:trigger "show"
    :value "show treatment"
    :title "Treatments"}
   {:trigger "show"
    :value "show instrument"
    :title "Instruments"}
   {:trigger "show"
    :value "show all"
    :title "All"}])

(defn- symptom-suggestion [tag]
  {:trigger "for"
   :value (str "for " tag)
   :title tag})

;; Symptoms and Conditions
(defn- gen-symptoms+conditions
  "All tags from treatments"
  []
  (map symptom-suggestion
   (reduce clojure.set/union
	   (map #(set (concat (:tags %) (:nicknames %)))
		(fetch-models :treatment :only [:tags :nicknames])))))

;; Instrument
(defn- instrument-suggestion [inst]
  {:trigger "use"
   :title (:variable inst)
   :value (str "use " (serialize-id (:_id inst)))
   :search (str (:nicknames inst) " " (:src inst))
   })

(defn- gen-instruments []
  (map instrument-suggestion
       (fetch-models :instrument :only [:variable :nicknames :src])))

;; Treatment
(defn- treatment-suggestion [treat]
  {:trigger "with"
   :value (str "with " (serialize-id (:_id treat)))
   :title (:name treat)
   :search (:description treat)})
  
(defn- gen-treatments []
  (map treatment-suggestion
       (fetch-models :treatment :only [:name :description])))

(defn compute-suggestions []
  (concat
   (gen-types)
   (gen-treatments)
   (gen-symptoms+conditions)
   (gen-instruments)))


;;
;; API for taking filter conditions and returning a list of model references
;;

(defn- model->client-ref [model]
  (if (and (:type model) (:_id model))
    [(:type model) (serialize-id (:_id model))]
    []))

(defn- model->db-id [model]
  (assert (= (type (:_id model)) ObjectId))
  (:_id model))

(defn- id->db-id [id]
  (mongo/object-id id))

(defn- strip-filters [type filters]
  (map #(.substring % (+ 1 (count type)))
       (filter #(re-find (re-pattern (str "^" type " ")) %) filters)))

(defn- show? [type filters]
  (let [types (set (strip-filters "show" filters))]
    (or (empty? types)
	(types "all")
	(types type))))

(defn- fulltext-regex [filters]
  (str/join "|"
   (filter #(not (re-find #"^(show|with|for|use)" %)) filters)))

(defn- treatment-filter [filters]
  (let [fors (strip-filters "for" filters)
	ids (strip-filters "with" filters)
	fulltext (fulltext-regex filters)]
    (merge (when (not (empty? fors))
	     {:tags {:$in fors}})
	   (when (not (empty? ids))
	     {:_id {:$in ids}})
	   (when (> (count fulltext) 0)
	     {:description {:$regex fulltext :$options "i"}}))))

(defn- filter-treatments [filters]
  (if (some #(re-find #"^use" %) filters)
    []
    (fetch-models :treatment (treatment-filter filters))))

(defn- instrument-filter [filters]
  (let [fulltext (fulltext-regex filters)
	fors (strip-filters "for" filters)]
    (merge
     (when (> (count fulltext) 0)
       {:description {:$regex fulltext :$options "i"}})
     (when (not (empty? fors))
       {:tags {:$all fors}}))))

(defn- filter-instruments [filters]
  (if (some #(re-find #"^use|^with" %) filters)
    []
    (fetch-models :instrument  (instrument-filter filters))))

(defn- experiment-filter [treatments filters]
  (let [fulltext (fulltext-regex filters)
	with-refs (map id->db-id (strip-filters "with" filters))
	treatment-refs (map model->db-id treatments)
	treatment-ids (concat with-refs treatment-refs)
	instrument-ids (map id->db-id (strip-filters "use" filters))]
    (merge (when (not (empty? fulltext))
	     {}) ;; NOTE: fulltext search of comments?
	   (when (not (empty? treatment-ids))
	     {:treatment.$id {:$in treatment-ids}})
	   (when (not (empty? instrument-ids))
	     {:instruments.$id {:$in instrument-ids}}))))

(defn- filter-experiments [treatments filters]
  (fetch-models :experiment (experiment-filter treatments filters)))

(defn filter-models [filters]
  (let [treatments (filter-treatments filters)
        instruments (filter-instruments filters)
        experiments (filter-experiments treatments filters)]
    (concat (when (show? "experiment" filters) experiments)
	    (when (show? "treatment" filters) treatments)
	    (when (show? "instrument" filters) instruments))))
  

(defpage filtered-search "/api/fsearch" {:keys [query limit]}
  (let [filters (str/split query #",")]
    (response/json
     (vec
      (map model->client-ref
	   (filter-models filters))))))

;;
;; New Style Search
;; -----------------------------------

;; ## Special constraints on search

(defn trim-plural [string]
  (if (= (last string) \s)
    (.substring string 0 (- (count string) 1))
    string))

(def constraint-exprs
  [[:type "show" trim-plural]
   [:tags "for"]
   [:treatment "with"]
   [:service "using"]])

(defn- match-prefix [term arg]
  (some (fn [[field prefix pfn]]
          (when (= term prefix)
            {field ((or pfn identity) arg)}))
        constraint-exprs))

(defn- parse-query-map [query]
  (if (= query "*")
    {:type "treatment"}
    (loop [terms (str/split query #" ")
           cmap {}
           default-query ""]
      (if (< (count terms) 2)
        (assoc cmap
          :default (str/trim (str/join " " (cons default-query terms))))
        (if-let [constraint (match-prefix (first terms) (second terms))]
          (recur (drop 2 terms) (merge cmap constraint) default-query)
          (recur (drop 1 terms) cmap (str/join " " [(first terms) default-query])))))))

(defn search-response [result-map]
  (response/json
   (dissoc
    (update-in result-map [:models] (comp vec server->client))
    :results)))

(defpage query-srch "/api/search/query/:q/:n/:skip" {:keys [q n skip]}
  (let [n (Integer/parseInt (or n "10"))
        skip (Integer/parseInt (or skip "0"))]
    (search-response
     (ft/search (parse-query-map q) :size n :skip skip))))
    
(defpage tag-srch "/api/search/tag/:q/:n/:skip" {:keys [q n skip]}
  (let [n (Integer/parseInt (or n "10"))
        skip (Integer/parseInt (or skip "0"))]
    (search-response
     (ft/search {:tags q} :size n :skip skip))))

;; RELATED OBJECTS (Treatment->Experiments, Outcomes)

(defn fetch-related [type dbref]
  (case type
    "treatment"
    (fetch-models :experiment {:treatment dbref})
    "experiment"
    (let [model (resolve-dbref dbref)]
      (remove #(= % model)
              (fetch-models :experiment
                            {:$or [{:treatment (:treatment model)}
                                   {:covariates {:$in (:covariates model)}}]})))
    "instrument"
    (let [inst (resolve-dbref dbref)]
      (concat (fetch-models :experiment {:instruments dbref})
              (remove #(= % inst)
                      (fetch-models :instrument {:service (:service inst)}))))))

(defpage related "/api/search/related/:type/:id" {:keys [type id]}
  (let [oid (deserialize-id id)
        ref (as-dbref type oid)]
    (let [results (fetch-related type ref)]
      (search-response
       {:models results
        :hits (count results)}))))
                                                      
