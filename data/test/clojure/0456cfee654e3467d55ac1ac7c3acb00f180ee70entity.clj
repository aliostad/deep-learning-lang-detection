(ns krivah.entity
	(:require [krivah.response :as response]
		[krivah.theme :as theme]
		[krivah.formelements :as fe]
		[krivah.db :as db])
)

(defmulti extract-field-value (fn [req index] (get req (str "formtype" index))))

(defmethod extract-field-value "text" [req index] 
	(assoc {} :label (get req (str "itemlabel" index)) :machinename (get req (str "machinename" index)) :type "text")
)

(defmethod extract-field-value "select" [req index]
	(def option-count (get req (str "selectcount_formtype" index)))
	(def values (loop [vals [] i 1]
		(if-not (> i (Integer/parseInt option-count))
			(recur (assoc vals (count vals) {:option (get req (str "selectoption" i)) :value (get req (str "selectvalue" i))}) (inc i))
			vals)))
	(assoc {} :label (get req (str "itemlabel" index)) :machinename (get req (str "machinename" index)) :type "select" :options values)
)

(defmethod extract-field-value :default [req index] (println "nothing"))

(defn entity-fields-to-form [fields]
	(apply merge (map #(assoc {} (keyword (get % :machinename)) 
		(assoc {} :label (get % :label) :id (get % :machinename) :type (get % :type ))) fields)))

(defn store-entity [form-value]
)

(defn create [request params]
(def media {:scripts (list {:src "/js/jquery.min.js"} {:src "/js/addfield.js"}) :style (list {:href "/css/entity.css"})})

	(if (identical? (:request-method request) (keyword "post"))
	(do
		(def field-count (Integer/parseInt (get (:form-params request) "fieldcount")))
		(def fields (loop [f [] i 1 ]
		(if-not (> i field-count)
			(recur (assoc f (count f) (extract-field-value (:form-params request) i)) (inc i))
			f)))
		(db/add-item "entities" {:label (get (:form-params request) "entity_label") :machinename (get (:form-params request) "entity_machinename") :fields fields})
			(response/http-response :body (theme/theme-response request "Entity created successfully.")))
			(response/http-response :body (theme/theme-response request (fe/html-from-file "krivah/templates/entity.html") media))))

	
(defn new-instance [request params]

	(def form (entity-fields-to-form (:fields (first (db/fetch-one-where "entities" {:machinename  (first params)})))))
	(fe/manage-form form store-entity)
)
