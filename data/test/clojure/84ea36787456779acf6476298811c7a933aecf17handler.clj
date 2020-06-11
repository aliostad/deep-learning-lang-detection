(ns treebank-viz.handler
  (:require
    [compojure.core :refer :all]
    [compojure.handler :as handler]
    [clojure.pprint :refer [pprint]]
    [clojure.data.json :as json]
    [ring.middleware.params :refer [wrap-params]]
    [ring.logger.timbre :as logger.timbre]
    [metrics.ring.expose :refer [expose-metrics-as-json]]
    [metrics.ring.instrument :refer [instrument]]
    [ring.util.io :refer [piped-input-stream]]
    [ring.util.response :refer [response content-type charset status]]
    [helpmate.html :refer :all]
    [treebank-viz.svg :refer :all]
    [treebank-viz.core :refer :all]))

(def no-sentence
  (-> (response "No sentence supplied") (status 400)))

(def index-page
  (html
    (div
      (form :type "post" :action "/svg")
      (input :type "text" :placeholder "Enter a setence" :name "q" :size 50)
      (input :type "submit" :value "svg"))))

(defn svg [sentence]
  (if (seq sentence)
    (let [result (analyze sentence)
          nodes  (node-finder result)
          edges  (edge-finder result)
          labels (leaf-finder result)]
      (->
        #(->svg nodes edges labels %)
        (piped-input-stream)
        (response)
        (content-type "image/svg+xml")
        (charset "UTF-8")))
    no-sentence))

(defn text [sentence]
  (if (seq sentence)
    (let [result (analyze sentence)]
      (->
        #(with-open [out (clojure.java.io/writer %)] (pprint result out))
        (piped-input-stream)
        (response)
        (content-type "text/plain")
        (charset "UTF-8")))
    no-sentence))

(defn json [sentence]
  (if (seq sentence)
    (let [result (analyze sentence)]
      (->
        result
        (json/write-str)
        (response)
        (content-type "application/json")
        (charset "UTF-8")))
    no-sentence))

(defroutes app-routes
  (GET "/svg"  [:as req] (svg (get-in req [:params :q])))
  (GET "/text" [:as req] (text (get-in req [:params :q])))
  (GET "/json" [:as req] (json (get-in req [:params :q])))
  (GET "/"     [:as req] (->
                           (response index-page)
                           (content-type "text/html")
                           (charset "UTF-8"))))

(def app
  (->
    (handler/site app-routes)
    (logger.timbre/wrap-with-logger)
    (expose-metrics-as-json)
    (instrument)
    (wrap-params)))
