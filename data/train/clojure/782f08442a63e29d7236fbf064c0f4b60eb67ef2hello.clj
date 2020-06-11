(ns hello-world
  (:use compojure.core, ring.adapter.jetty, incanter.core, incanter.stats, incanter.charts,
	incanter.io ,hiccup.core)
  (:require [compojure.route :as route])
  (:import (java.io ByteArrayOutputStream
                    ByteArrayInputStream)
           (java.lang Integer)))

(use '(com.evocomputing rincanter))

;; Pass a map as the first argument to be 
;; set as attributes of the element
(defn html-doc 
  [title & body] 
  (html 
       [:div 
	[:h2 
	 [:a {:href "/"} 
          "Generate a normal sample"]]]
       body)) 

(defn gen-samp-hist-png 
  [size-str mean-str sd-str] 
    (let [size (if (nil? size-str) 
                 1000 
                 (Integer/parseInt size-str))
          m (if (nil? mean-str) 
              0 
              (Double/parseDouble mean-str))
          s (if (nil? sd-str) 
              1 
              (Double/parseDouble sd-str))
          samp (sample-normal size 
                              :mean m 
                              :sd s)
          chart (histogram 
                  samp
                  :title "Normal Sample"
                  :x-label (str "sample-size = " size 
                                ", mean = " m 
                                ", sd = " s))
          out-stream (ByteArrayOutputStream.)
          in-stream (do
                      (save chart out-stream)
                      (ByteArrayInputStream. 
		       (.toByteArray out-stream)))]
      
      {:status 200
       :headers {"Content-Type" "image/png"}
       :body in-stream}))

(defn species-graph
  [id]
  (let [species-data (read-dataset "data/test.txt" :header true :delim \tab)
	species-data-country (sel species-data :filter #(= (nth % 1) id))
	species (sel species-data-country :cols 10)
	weight (sel species-data-country :cols 11)
	chart (line-chart species weight :title id)
	out-stream (ByteArrayOutputStream.)
	in-stream (do
		    (save chart out-stream)
		    (ByteArrayInputStream. 
		     (.toByteArray out-stream)))]
    
    {:status 200
     :headers {"Content-Type" "image/png"}
     :body in-stream}))

(defn by-day
  [byday bymonth byyear]
  (with-data (read-dataset "data/logbook.csv" :header true)
    (let [chart (doto (scatter-plot :lat :lon
                                    :title (str byday "/" bymonth "/" byyear)
                                    :data ($where {:day (Integer/parseInt byday)
                                                   :month (Integer/parseInt bymonth)
                                                   :year (Integer/parseInt byyear)})))
          out-stream (ByteArrayOutputStream.)
          in-stream (do
                      (save chart out-stream)
                      (ByteArrayInputStream. 
                       (.toByteArray out-stream)))]
          
      {:status 200
       :headers {"Content-Type" "image/png"}
       :body in-stream})))
  
(defn r-graph
  [id]
  (r-eval "source(\"src/script.R\")")
  (with-data (r-eval "bt")
     (let
	[chart (doto (scatter-plot :lon :lat :title "speed > 2.5 knots" :data ($where {:speed {:$gt 2.5}})) )
	out-stream (ByteArrayOutputStream.)
	in-stream (do
		    (save chart out-stream)
		    (ByteArrayInputStream. 
		     (.toByteArray out-stream)))
        ]
    
    {:status 200
     :headers {"Content-Type" "image/png"}
     :body in-stream})))
  
(defn r-histo
  [id]
  (r-eval "source(\"src/script.R\")")
  (with-data (r-eval "grilla.cpue$cpue")
     (let
	[chart (doto (histogram (sample-normal 1000)))
	out-stream (ByteArrayOutputStream.)
	in-stream (do
		    (save chart out-stream)
		    (ByteArrayInputStream. 
		     (.toByteArray out-stream)))
        ]
    
    {:status 200
     :headers {"Content-Type" "image/png"}
     :body in-stream})))



;; define routes
(defroutes webservice
  (GET "/sample-normal" {params :params} 
       (gen-samp-hist-png (params :size) 
                          (params :mean) 
                          (params :sd)))
  (GET "/species/:id" [id] (species-graph id) )
  (GET "/coralfish/r" [id] (r-graph id) )
  (GET "/coralfish/r/histo" [id] (r-histo id) )
  (GET "/coralfish/day/:day/month/:month/year/:year" [day month year]
       (by-day day month year) ))
       
(run-jetty webservice {:port 8000})
  
